module TelegramBot
  class InlineQueryResultDocument < InlineQueryResult
    include JSON::Serializable

    property type : String = "document"
    property id : String
    property title : String
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
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
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @document_url : String,
      @mime_type : String,
      @description : String? = nil,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @input_message_content : InputMessageContent? = nil,
      @thumbnail_url : String? = nil,
      @thumbnail_width : Int32? = nil,
      @thumbnail_height : Int32? = nil,
    )
    end
  end
end
