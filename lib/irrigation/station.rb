module Irrigation
  class Station
    attr_accessor :id, :description, :state, :schedules

    OFF = 'off'
    ON = 'on'

    def initialize(opts)
      @id = opts.fetch(:id)
      @client = opts.fetch(:client)
      @schedules = Array(opts[:schedules])
      @description = opts[:description]
      @state = OFF
    end

    def on!
      @client.send_command(self, ON)
    end

    def off!
      @client.send_command(self, OFF)
    end

    def find_schedule_by_id(schedule_id)
      @schedules.find { |s| s.id == schedule_id }
    end

    def add_schedule(schedule)
      @schedules << schedule
    end

    def remove_schedule(schedule_id)
      @schedules.delete_if { |s| s.id == schedule_id }
    end

    private

  end
end
