require 'mqtt'

module Irrigation
  class MqttClient
    attr_reader :host, :port

    def initialize(opts)
      @host = opts.fetch(:host) { 'localhost' }
    end

    def send_command(station, command)
      @client.publish("command/#{station.id}", command)
    end

    def get_status(&block)
      @client.subscribe('status/#')
      @client.get &block
    end
  end
end
