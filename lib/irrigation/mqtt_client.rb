require 'mqtt'

module Irrigation
  class MqttClient
    def initialize(opts)
      @client = opts.fetch(:mqtt_client)
    end

    def send_command(station, command)
      @client.publish("command/#{station.id}", command)
    end
  end
end
