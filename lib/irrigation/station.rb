module Irrigation
  class Station
    attr_reader :id, :description, :state

    OFF = 'off'
    ON = 'on'

    def initialize(opts)
      @id = opts.fetch(:id)
      @command_sender = opts.fetch(:command_sender)
      @description = opts[:description]
      @state = OFF
    end

    def on!
      @command_sender.send(self, ON)
    end

    def off!
      @command_sender.send(self, OFF)
    end

    def update(topic, message)
      if topic.match(/@id$/)
        @state = State(message)
      end
    end

    private

    def State(message)
      if message.match(/on/i)
        ON
      elsif message.match(/off/i)
        OFF
      end
    end
  end
end
