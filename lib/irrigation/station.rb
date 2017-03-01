module Irrigation
  class Station
    attr_reader :id, :description, :state, :schedules

    OFF = 'off'
    ON = 'on'

    def initialize(opts)
      @id = opts.fetch(:id)
      @description = opts[:description]
      @state = OFF
    end

    def update(message)
      @state = state_for(message)
    end

    def to_h
      {
        id: id,
        description: description,
        state: state
      }
    end

    def self.state_for(message)
      if message.match(/on/i)
        Station::ON
      else
        Station::OFF
      end
    end
  end
end
