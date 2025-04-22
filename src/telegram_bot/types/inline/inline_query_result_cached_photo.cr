module TelegramBot
  class InlineQueryResultCachedPhoto < InlineQueryResult
    include JSON::Serializable

    property type : String = "photo"
    property id : String
    property photo_file_id : String
    property title : String?
    property description : String?
    property caption : String?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @photo_file_id : String,
      *,
      @title = nil,
      @description = nil,
      @caption = nil,
      @reply_markup = nil,
      @input_message_content = nil,
    )
    end
  end
end
