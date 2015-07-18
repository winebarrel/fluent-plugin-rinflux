$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'fluent/test'
require 'fluent/plugin/out_rinflux'
require 'time'

# Disable Test::Unit
module Test::Unit::RunCount; def run(*); end; end

RSpec.configure do |config|
  config.before(:all) do
    Fluent::Test.setup
  end
end

def create_driver(options = {})
  tag = options.delete(:tag) || 'test.default'

  fluentd_conf = <<-EOS
type rinflux
db #{options.delete(:db)}
  EOS

  options.each do |key, value|
    fluentd_conf << "#{key} #{value}\n"
  end

  Fluent::Test::OutputTestDriver.new(Fluent::RinfluxOutput, tag).configure(fluentd_conf)
end
