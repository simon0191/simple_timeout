module SimpleTimeout
  def self.timeout(seconds,timeout_error_class=SimpleTimeout::Error,wait_for_block=false,&block)
    if seconds == 0
      raise timeout_error_class.new, "execution expired"
    end

    if seconds.nil? || !seconds.is_a?(Numeric) || seconds < 0
      raise ArgumentError.new, "seconds must be an Integer number greater or equal to 0"
    end

    if block_given?
      control = SimpleTimeout::Control.new(seconds,timeout_error_class)

      block_thread = build_block_thread(control,&block)

      timeout_thread = build_timeout_thread(control)

      while control.status == :waiting;end
      
      timeout_thread.kill if timeout_thread.alive?
      block_thread.kill if block_thread.alive?

      if wait_for_block
        block_thread.join
      end

      handle_control_status control

    end
  end

  class Error < ::StandardError; end

  private

    class Control
      attr_accessor :mutex,:status,:result,:error,:timeout_in_seconds,:timeout_error_class
      def initialize(timeout_in_seconds,timeout_error_class)
        self.timeout_in_seconds = timeout_in_seconds
        self.timeout_error_class = timeout_error_class
        self.status = :waiting
        self.mutex = Mutex.new
        self.result = nil
        self.error = nil
      end
    end

    def self.build_block_thread(control,&block)
      Thread.new(control) do |control|
        begin
          control.result = block.call
        rescue Exception => e
          control.error = e
        end
        control.mutex.synchronize do
          if control.status == :waiting
            control.status = :finished
          end
        end
      end
    end

    def self.build_timeout_thread(control)
      Thread.new(control) do |control|
        sleep(control.timeout_in_seconds)
        control.mutex.synchronize do
          if control.status == :waiting
            control.status = :timeout
          end
        end
      end
    end

    def self.handle_control_status(control)
      if control.status == :finished
        if control.error.nil?
          return control.result
        else
          raise control.error.class.new, control.error.message
        end
      else
        raise control.timeout_error_class.new, "execution expired"
      end
    end
end
