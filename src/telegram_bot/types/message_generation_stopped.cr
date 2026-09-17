module TelegramBot
  class MessageGenerationStopped
    include JSON::Serializable

    property chat : Chat
    property message_thread_id : Int32?
    property draft_id : Int32

    def initialize(
      @chat : Chat,
      @draft_id : Int32,
      *,
      @message_thread_id : Int32? = nil,
    )
    end
  end
end
