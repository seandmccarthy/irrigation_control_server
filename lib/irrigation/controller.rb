require 'rufus-scheduler'
require 'json'

module Irrigation
  class Controller

    def initialize(opts)
      @stations = Array(opts.fetch(:stations))
      @scheduler = opts.fetch(:schedule) { Rufus::Scheduler.new }
    end

    def start
      start_schedules
      status_poller
    end

    def stations
      {
        stations: @stations.map { |station| station_json(station) }
      }.to_json
    end

    def station_json(station)
      {
        id: station.id,
        description: station.description,
        state: station.state,
        schedules: station.schedules.map { |s| schedule_json(s) }
      }
    end

    def schedule_json(schedule)
      {
        id: schedule.id,
        start_hour: schedule.start_hour,
        start_minute: schedule.start_minute,
        duration: schedule.duration,
        days: schedule.days
      }
    end

    def get_station_by_id(id)
      @stations.find { |station| station.id == id.to_i }
    end

    def add_schedule(station, schedule)
      puts schedule.as_cron_string
      job_id = @scheduler.cron schedule.as_cron_string do
        station.on!
        sleep schedule.duration
        station.off!
      end
      schedule.job_id = job_id
      station.add_schedule(schedule)
      #persist_schedules(station)
    end

    def remove_schedule(station, job_id)
      scheduler.unschedule(job_id)
      station.remove_schedule(job_id)
    end

    private

    def start_schedules
    end

    def station_for(topic)
      _, station_id = topic.split('/')
      get_station_by_id(station_id)
    end

    def state_for(message)
      if message.match(/on/i)
        Station::ON
      else
        Station::OFF
      end
    end

    def status_poller
      Thread.new do
        @client.subscribe('status/#')
        @client.get do |topic, message|
          station_for(topic).state = state_for(message)
        end
      end
    end
  end
end
