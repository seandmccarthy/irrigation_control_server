require 'irrigation'

class RufusSchedulerTests < MiniTest::Unit::TestCase
  class MockClient
    attr_reader :messages
    def initialize
      @messages = []
    end

    def send_command(station, message)
      @messages << message
    end
  end

  def test_add_schedule
    client = MockClient.new
    scheduler = Irrigation::RufusScheduler.new([], client)
    now = Time.now
    schedule = Irrigation::Schedule.new(
      start_minute: now.min, start_hour: now.hour, duration: 1, days: now.wday)
    scheduler.add(schedule)
    sleep 5
  end
end
