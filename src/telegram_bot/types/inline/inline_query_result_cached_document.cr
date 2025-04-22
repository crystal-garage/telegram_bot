module TelegramBot
  class InlineQueryResultCachedDocument < InlineQueryResult
    include JSON::Serializable

    property type : String = "document"
    property id : String
    property title : String
    property document_file_id : String
    property description : String?
    property caption : String?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @title : String,
      @document_file_id : String,
      *,
      @description = nil,
      @caption = nil,
      @reply_markup = nil,
      @input_message_content = nil,
    )
    end
  end
end
