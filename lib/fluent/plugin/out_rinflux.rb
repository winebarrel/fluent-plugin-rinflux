require 'fluent_plugin_rinflux/version'

class Fluent::RinfluxOutput < Fluent::BufferedOutput
  Fluent::Plugin.register_output('rinflux', self)

  unless method_defined?(:log)
    define_method('log') { $log }
  end

  config_param :host, :string,  :default => 'localhost'
  config_param :port, :integer, :default => 8086
  config_param :db,   :string

  def initialize
    super
    require 'rinflux'
  end

  def start
    super
  end

  def shutdown
    super
  end

  def configure(conf)
    super
    @client = Rinflux::Client.new(:host => @host, :port => @port)
  end

  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  def write(chunk)
    chunk.msgpack_each do |tag, time, record|
      data_tags = record.delete('tags') || {}

      record.each do |key, value|
        options = {
          :db => @db,
          :tags => data_tags,
          :timestamp => time * (10 ** 9)
        }

        @client.write(key, value, options)
      end
    end
  end
end
