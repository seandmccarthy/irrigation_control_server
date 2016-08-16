require 'mqtt'

module Irrigation
  class CommandSender
    def initialize(opts)
      @client = opts.fetch(:client)
    end

    def send(station, message)
      @client.publish("command/#{station.id}", message)
    end
  end
end
