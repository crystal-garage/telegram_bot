module TelegramBot
  class InlineQueryResultCachedSticker < InlineQueryResult
    include JSON::Serializable

    property type : String = "sticker"
    property id : String
    property sticker_file_id : String
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @sticker_file_id : String,
      *,
      @reply_markup = nil,
      @input_message_content = nil,
    )
    end
  end
end
