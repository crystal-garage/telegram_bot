module TelegramBot
  class InlineQueryResultCachedAudio < InlineQueryResult
    include JSON::Serializable

    property type : String = "audio"
    property id : String
    property audio_file_id : String
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @audio_file_id : String,
      *,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @input_message_content : InputMessageContent? = nil,
    )
    end
  end
end
