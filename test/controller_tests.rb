require 'minitest/autorun'
require 'irrigation'
require 'json'

class ControllerTests < MiniTest::Unit::TestCase
  class TestScheduler; end
  class TestMessageClient; end
  class TestStatusWatcher; end

  def setup
    @station = Irrigation::Station.new(id: 1, description: 'station 1')
    @controller = Irrigation::Controller.new(
      stations: [ @station ],
      scheduler: TestScheduler.new,
      message_client: TestMessageClient.new,
      status_watcher: TestStatusWatcher.new
    )
  end

  def test_stations
    expected = {
      stations: [ @station.to_h ]
    }
    assert_equal expected, @controller.stations
  end
end
