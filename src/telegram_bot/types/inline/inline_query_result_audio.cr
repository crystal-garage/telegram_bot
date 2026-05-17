module TelegramBot
  class InlineQueryResultAudio < InlineQueryResult
    include JSON::Serializable

    property type : String = "audio"
    property id : String
    property audio_url : String
    property title : String
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property performer : String?
    property audio_duration : Int32?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @audio_url : String,
      @title : String,
      *,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @performer : String? = nil,
      @audio_duration : Int32? = nil,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @input_message_content : InputMessageContent? = nil,
    )
    end
  end
end
