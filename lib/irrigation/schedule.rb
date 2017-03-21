require 'time'

module Irrigation
  class Schedule
    attr_accessor :start_hour, :start_minute, :duration_in_seconds, :days, :job_id

    SUNDAY = 0
    MONDAY = 1
    TUESDAY = 2
    WEDNESDAY = 3
    THURSDAY = 4
    FRIDAY = 5
    SATURDAY = 6

    def self.create(opts)
      start = Time.parse(opts.fetch(:start_time))
      Schedule.new(opts.merge(start_minute: start.minute, start_hour: start.hour))
    end

    def initialize(opts)
      @start_minute = opts.fetch(:start_minute, 0)
      @start_hour = opts.fetch(:start_hour)
      @duration_in_seconds = opts.fetch(:duration)
      @days = Array(opts.fetch(:days))
    end
  end
end
