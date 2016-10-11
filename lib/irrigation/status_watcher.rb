require 'observer'

module Irrigation
  class StatusWatcher
    include Observable

    def initialize(opts)
      @client = opts.fetch(:client)
    end

    def run
      @thr = Thread.new do
        @client.get_status do |topic, message|
          changed
          notify_observers(topic, message)
        end
      end
    end

    def stop
      @thr.join
    end
  end
end
