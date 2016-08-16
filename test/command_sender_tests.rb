require 'minitest/autorun'
require 'irrigation'

class CommandSenderTests < Minitest::Test
  class MockClient
    attr_reader :topic, :message

    def publish(topic, message)
      @topic = topic
      @message = message
    end
  end

  def test_publish
    client = MockClient.new
    command_sender = Irrigation::CommandSender.new(client: client)
    station = Irrigation::Station.new(id: 1, command_sender: command_sender)
    station.on!
    assert_equal "command/#{station.id}", client.topic
    assert_equal Irrigation::Station::ON, client.message
  end
end
