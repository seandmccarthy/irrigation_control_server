require 'minitest/autorun'
require 'irrigation'
require 'json'

class ControllerTests < Minitest::Test

  class MockMQClient
  end

  def test_add_schedule
=begin
    schedule = Irrigation::Schedule.new(
      start_minute: 00,
      start_hour: 23,
      duration: 1,
      days: [1,2,3,4,5,6,7]
    )
    station = Irrigation::Station.new(
      id: 1
    )
    controller = Irrigation::Controller.new(
      stations: station,
    )
    controller.add_schedule(station, schedule)
=end
  end

  def test_stations_json
    schedule = Irrigation::Schedule.new(
      id: "1",
      start_minute: 0,
      start_hour: 23,
      duration: 1,
      days: [1,2,3,4,5,6,7]
    )
    station = Irrigation::Station.new(id: 1, client: :test, schedules: [ schedule ])
    controller = Irrigation::Controller.new(stations: station)
    expected = {
      stations: [
        {
          id: 1,
          description: nil,
          state: 'off',
          schedules: [
            {
              id: "1",
              start_hour: 23,
              start_minute: 0,
              duration: 1,
              days: [1,2,3,4,5,6,7]
            }
          ]
        }
      ]
    }
    assert_equal expected.to_json, controller.stations
  end
end
