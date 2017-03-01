require 'mqtt'

module Irrigation
  class MqttClient
    attr_reader :host, :port

    def initialize(opts)
      @host = opts.fetch(:host, 'localhost')
      @port = opts.fetch(:port, 1883)
    end

    def send_command(station, command)
      client.publish("command/#{station.id}", command)
    end

    def get_status(&block)
      client.subscribe('status/#')
      client.get &block
    end

    private

    def client
      reconnect unless @client && @client.connected?
      @client
    end

    def reconnect
      @client = MQTT::Client.connect(:host => @host, :port => @port)
    rescue => e
      # log ?
    end
  end
end
