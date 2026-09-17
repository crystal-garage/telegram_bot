module TelegramBot
  class InlineQueryResultCachedDocument < InlineQueryResult
    include JSON::Serializable

    property type : String = "document"
    property id : String
    property title : String
    property document_file_id : String
    property description : String?
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @title : String,
      @document_file_id : String,
      *,
      @description : String? = nil,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @input_message_content : InputMessageContent? = nil,
    )
    end
  end
end
