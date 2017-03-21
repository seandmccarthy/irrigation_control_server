require 'irrigation'

class StationJobTests < MiniTest::Unit::TestCase
  class MockClient
    attr_reader :messages
    def initialize
      @messages = []
    end

    def send_command(station, message)
      @messages << message
    end
  end

  def test_station_job_messages
    client = MockClient.new
    schedule = Irrigation::Schedule.new(start_hour: 1, duration: 0, days: 1)
    job = Irrigation::StationJob.new(client
    sleep 5
  end
end
