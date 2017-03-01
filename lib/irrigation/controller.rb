require 'rufus-scheduler'
require 'json'

module Irrigation
  class Controller

    def initialize(opts)
      @stations = Array(opts.fetch(:stations))
      @scheduler = opts.fetch(:scheduler) { Rufus::Scheduler.new }
      @client = opts.fetch(:message_client)
      @status_watcher = opts.fetch(:status_watcher) { StatusWatcher.new(client: @client) }
    end

    def start
      @status_watcher.add_observer(self)
      @status_watcher.run
      start_schedules
    end

    def stations
      {
        stations: @stations.map { |station| station.to_h }
      }
    end

    def send_command(station_id, message)
      station = get_station_by_id(station_id)
      command = Station.state_for(message)
      @client.send_command(station, command) unless station.nil? || command.nil?
    end

    # The receiving method for being notified, as an observer
    def update(topic, message)
      station_for(topic).update message
    rescue => e
      $stderr.puts "error: #{e.message}"
    end

    private

    def get_station_by_id(id)
      @stations.find { |station| station.id == id.to_i }
    end

    def add_schedule(station, schedule)
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

    def start_schedules
    end

    def station_for(topic)
      _, station_id = topic.split('/')
      get_station_by_id(station_id)
    end
  end
end
