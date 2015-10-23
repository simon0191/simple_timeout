require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require "bundler/setup"
Bundler.require(:default)
require "rspec"
require "byebug"

RSpec.configure do |config|
  config.color = true
end
