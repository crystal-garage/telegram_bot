module TelegramBot
  class InlineQueryResultVoice < InlineQueryResult
    include JSON::Serializable

    property type : String = "voice"
    property id : String
    property voice_url : String
    property title : String
    property caption : String?
    property parse_mode : String?
    property voice_duration : Int32?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @voice_url : String,
      @title : String,
      *,
      @caption = nil,
      @parse_mode = nil,
      @voice_duration = nil,
      @reply_markup = nil,
      @input_message_content = nil,
    )
    end
  end
end
