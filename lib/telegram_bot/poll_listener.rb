class TelegramBot
  class PollListener
    def initialize(client, interval)
      @client    = client
      @interval  = interval
      @offset_id = nil
    end

    def message_received(msg)
      @client.append_history(msg)
      begin
        @client.handle(msg)
      rescue => e
        puts e.inspect
      end
    end

    def start!
      loop do
        get_updates
        sleep @interval
      end
    end

    def get_updates
      updates = @client.get_updates(offset: @offset_id,
                                    limit: 50)
      updates.each do |update|
        @offset_id = update.id + 1
        message_received(update.message)
      end
    end
  end
end
