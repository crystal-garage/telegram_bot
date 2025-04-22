module TelegramBot
  class InlineQueryResultAudio < InlineQueryResult
    include JSON::Serializable

    property type : String = "audio"
    property id : String
    property audio_url : String
    property title : String
    property performer : String?
    property audio_duration : Int32?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @audio_url : String,
      @title : String,
      *,
      @performer = nil,
      @audio_duration = nil,
      @reply_markup = nil,
      @input_message_content = nil,
    )
    end
  end
end
