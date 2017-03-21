module Irrigation
  class RufusScheduler
    def initialize(schedules, client)
      @scheduler = Rufus::Scheduler.new
      @client = client
    end

    def add(station, schedule)
      job = StationJob.new(station, @client, schedule.duration_in_seconds)
      schedule.job_id = @scheduler.cron cron_entry_for(schedule), job
    end

    def remove(schedule)
      @scheduler.unschedule(schedule.job_id)
    end

    def remove_all
      @scheduler.cron_jobs.each(&:unschedule)
    end

    def cron_entry_for(schedule)
      "#{schedule.start_minute} #{schedule.start_hour} * * #{schedule.days.join(',')}"
    end
  end
end
