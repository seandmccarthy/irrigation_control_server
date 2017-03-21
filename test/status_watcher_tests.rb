require 'minitest/autorun'
require 'irrigation'

class StatusWatcherTests < MiniTest::Unit::TestCase
  class MockClient
    def get_status
      yield 'a topic', 'a message'
    end
  end

  class MockObserver
    attr_reader :topic, :message

    def update(topic, message)
      @topic = topic
      @message = message
    end
  end

  def test_notification
    status_watcher = Irrigation::StatusWatcher.new(client: MockClient.new)
    observer = MockObserver.new
    status_watcher.add_observer(observer)
    status_watcher.run
    status_watcher.stop
    assert_equal 'a topic', observer.topic
    assert_equal 'a message', observer.message
  end
end
