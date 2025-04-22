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
    property thumb_url : String?
    property thumb_width : Int32?
    property thumb_height : Int32?

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
      @thumb_url = nil,
      @thumb_width = nil,
      @thumb_height = nil,
    )
    end
  end
end
