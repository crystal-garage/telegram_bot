module TelegramBot
  class InlineQueryResultCachedVoice < InlineQueryResult
    include JSON::Serializable

    property type : String = "voice"
    property id : String
    property voice_file_id : String
    property title : String
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @voice_file_id : String,
      @title : String,
      *,
      @reply_markup = nil,
      @input_message_content = nil,
    )
    end
  end
end
