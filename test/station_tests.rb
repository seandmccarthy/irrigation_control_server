require 'minitest/autorun'
require 'irrigation'
require 'yaml'

class StationTests < Minitest::Test
  class MockClient
    attr_accessor :state

    def send_command(station, state)
      @state = state
    end
  end

  def test_on
    client = MockClient.new
    station = Irrigation::Station.new(id: 1, client: client)
    station.on!
    assert_equal Irrigation::Station::ON, client.state
  end
  
  def test_off
  end

  def test_persistence
    schedule = Irrigation::Schedule.new(
      start_minute: 44,
      start_hour: 10,
      duration: 20,
      days: [1,3,5]
    )
    station = Irrigation::Station.new(
      id: 1,
      schedules: Array(schedule),
      client: MockClient.new
    )
    persisted = YAML::dump(station)
    station_out = YAML::load(persisted)
    assert_equal station.id, station_out.id
    assert_equal 1, station_out.schedules.size
    assert_equal 10, station_out.schedules.first.start_hour
  end
end
