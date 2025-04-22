module TelegramBot
  class InlineQueryResultCachedAudio < InlineQueryResult
    include JSON::Serializable

    property type : String = "audio"
    property id : String
    property audio_file_id : String
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @audio_file_id : String,
      *,
      @reply_markup = nil,
      @input_message_content = nil,
    )
    end
  end
end
