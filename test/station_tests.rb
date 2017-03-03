require 'minitest/autorun'
require 'irrigation'
require 'yaml'

class StationTests < MiniTest::Unit::TestCase
  def setup
    @station = Irrigation::Station.new(id: 1)
  end

  def test_update_for_on_message
    @station.update('on')
    assert_equal Irrigation::Station::ON, @station.state
  end
  
  def test_update_for_off_message
    @station.update('off')
    assert_equal Irrigation::Station::OFF, @station.state
  end

  def test_state_is_off_for_unknown_message
    @station.update('foo')
    assert_equal Irrigation::Station::OFF, @station.state
  end
end
