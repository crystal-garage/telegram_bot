module TelegramBot
  class InlineQueryResultVoice < InlineQueryResult
    include JSON::Serializable

    property type : String = "voice"
    property id : String
    property voice_url : String
    property title : String
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property voice_duration : Int32?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @voice_url : String,
      @title : String,
      *,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @voice_duration : Int32? = nil,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @input_message_content : InputMessageContent? = nil,
    )
    end
  end
end
