require_relative "spec_helper"

RSpec.describe SimpleTimeout do

  let(:small_timeout) { 0.1 }
  let(:medium_timeout) { 0.4 }
  let(:big_timeout) { 1 }

  describe "#timeout" do
    context "0 seconds" do
      it "should raise a SimpleTimeout::Error" do
        expect {SimpleTimeout.timeout(0)}.to raise_error(SimpleTimeout::Error)
      end
    end
    context "negative seconds" do
      it "should raise an ArgumentError" do
        expect {SimpleTimeout.timeout(-1)}.to raise_error(ArgumentError)
      end
    end
    context "nil seconds" do
      it "should raise an ArgumentError" do
        expect {SimpleTimeout.timeout(nil)}.to raise_error(ArgumentError)
      end
    end
    context "non Integer seconds" do
      it "should raise an ArgumentError" do
        expect {SimpleTimeout.timeout( {} )}.to raise_error(ArgumentError)
      end
    end
    context "block is not given" do
      it "should return nil" do
        expect(SimpleTimeout.timeout(small_timeout)).to be_nil
      end
    end
    context "block raise an Error" do
      it "should raise the Error" do
        class SomeError < StandardError;end
        message = "Some message"
        expect do
          SimpleTimeout.timeout(big_timeout) { raise SomeError.new(message) }
        end.to raise_error(SomeError,message)
      end
    end
    context "block execution takes more time than timeout" do
      it "should kill block thread" do
        thread_spy = spy('thread')
        allow(SimpleTimeout).to receive(:build_block_thread).and_return(thread_spy)
        begin
          SimpleTimeout.timeout(small_timeout) {  }
          fail
        rescue SimpleTimeout::Error => e
          expect(thread_spy).to have_received(:kill)
        end
      end

      it "should raise SimpleTimeout::Error" do
        expect do
          SimpleTimeout.timeout(small_timeout) { sleep(big_timeout) }
        end.to raise_error(SimpleTimeout::Error)
      end

      context "and is given a custom error class" do
        it "should raise SimpleTimeout::Error" do
          class SomeError < StandardError;end
          expect do
            SimpleTimeout.timeout(small_timeout,SomeError) { sleep(big_timeout) }
          end.to raise_error(SomeError)
        end
      end

      context "and block execution can't be killed" do
        it "should finish and raise SimpleTimeout::Error" do
          thread_stub = Thread.new { while true; end }
          allow(SimpleTimeout).to receive(:build_block_thread).and_return(thread_stub)
          allow(thread_stub).to receive(:kill).and_return(nil)
          expect{ SimpleTimeout.timeout(small_timeout) {  } }.to raise_error(SimpleTimeout::Error)
        end

        context "and wait_for_block is true" do
          it "should wait until the block finishes execution" do
            thread_spy = spy('thread')
            allow(SimpleTimeout).to receive(:build_block_thread).and_return(thread_spy)

            expect{
              SimpleTimeout.timeout(small_timeout,SimpleTimeout::Error,true) {  }
            }.to raise_error(SimpleTimeout::Error)
            
            expect(thread_spy).to have_received(:join)
          end
        end
      end


    end
    context "block execution finishes before timeout" do
      it "should return what the block returned" do
        expected_return = "Expected return value"
        expect(
          SimpleTimeout.timeout(big_timeout,SomeError) { expected_return }
        ).to eq expected_return
      end
      it "should kill timeout thread" do
        thread_spy = spy('thread')
        allow(SimpleTimeout).to receive(:build_timeout_thread).and_return(thread_spy)
        SimpleTimeout.timeout(small_timeout) {  }
        expect(thread_spy).to have_received(:kill)
      end
    end
  end

end
