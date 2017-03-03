require 'minitest/autorun'
require 'irrigation'

class StatusWatcherTests < MiniTest::Unit::TestCase
  class MockClient
    def get_status
      yield 'a topic', 'a message'
    end
  end

  class MockObserver
    attr_reader :notify_count

    def initialize
      @notify_count = 0
    end

    def update(*args)
      @notify_count += 1
    end
  end

  def test_notification
    status_watcher = Irrigation::StatusWatcher.new(client: MockClient.new)
    observer = MockObserver.new
    status_watcher.add_observer(observer)
    status_watcher.run
    status_watcher.stop
    assert_equal 1, observer.notify_count
  end
end
