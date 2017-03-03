require 'irrigation'

class ScheduleTests < MiniTest::Unit::TestCase
  def test_generate_id
    schedule = Irrigation::Schedule.new(start_hour: 1, duration: 1, days: 1)
    refute_nil schedule.id
  end

  def test_requires_start_hour
    assert_raises(KeyError) { Irrigation::Schedule.new(duration: 1, days: 1) }
  end

  def test_requires_duration
    assert_raises(KeyError) { Irrigation::Schedule.new(start_hour: 1, days: 1) }
  end

  def test_requires_days
    assert_raises(KeyError) { Irrigation::Schedule.new(duration: 1, start_hour: 1) }
  end

  def test_start_minute_default
    schedule = Irrigation::Schedule.new(start_hour: 1, duration: 1, days: 1)
    assert_equal 0, schedule.start_minute
  end
end
