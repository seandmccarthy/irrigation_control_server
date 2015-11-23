module Irrigation
  class Schedule
    attr_accessor :id, :start_hour, :start_minute, :duration, :days, :job_id
    SUNDAY = 0
    MONDAY = 1
    TUESDAY = 2
    WEDNESDAY = 3
    THURSDAY = 4
    FRIDAY = 5
    SATURDAY = 6

    def initialize(opts)
      @id = opts.fetch(:id) { generate_id }
      @start_minute = opts.fetch(:start_minute, 0)
      @start_hour = opts.fetch(:start_hour)
      @duration = opts.fetch(:duration)
      @days = Array(opts.fetch(:days))
    end

    def as_cron_string
      "#{@start_minute} #{@start_hour} * * #{@days.join(',')}"
    end

    private

    def generate_id
      DateTime.now.strftime('%Q')
    end
  end
end
