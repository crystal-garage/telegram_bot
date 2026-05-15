module TelegramBot
  class ReplyParameters
    include JSON::Serializable

    property message_id : Int32
    property chat_id : Int64 | String?
    property? allow_sending_without_reply : Bool?
    property quote : String?
    property quote_parse_mode : String?
    property quote_entities : Array(MessageEntity)?
    property quote_position : Int32?
    property checklist_task_id : Int32?
    property poll_option_id : String?

    def initialize(
      @message_id : Int32,
      *,
      @chat_id = nil,
      @allow_sending_without_reply = nil,
      @quote = nil,
      @quote_parse_mode = nil,
      @quote_entities = nil,
      @quote_position = nil,
      @checklist_task_id = nil,
      @poll_option_id = nil,
    )
    end
  end
end
