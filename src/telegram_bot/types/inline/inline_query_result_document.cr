module TelegramBot
  class InlineQueryResultDocument < InlineQueryResult
    include JSON::Serializable

    property type : String = "document"
    property id : String
    property title : String
    property caption : String?
    property document_url : String
    property mime_type : String
    property description : String?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?
    property thumbnail_url : String?
    property thumbnail_width : Int32?
    property thumbnail_height : Int32?

    def initialize(
      @id : String,
      @title : String,
      *,
      @caption = nil,
      @document_url : String,
      @mime_type : String,
      @description = nil,
      @reply_markup = nil,
      @input_message_content = nil,
      @thumbnail_url = nil,
      @thumbnail_width = nil,
      @thumbnail_height = nil,
    )
    end
  end
end
