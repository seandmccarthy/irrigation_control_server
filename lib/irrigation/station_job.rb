module Irrigation
  class StationJob
    def initialize(station, client, duration)
      @station = station
      @client = client
      @duration = duration
    end

    def call(job)
      @client.send_command(@station, Station::ON)
      sleep(@duration)
      @client.send_command(@station, Station::OFF)
    end
  end
end
