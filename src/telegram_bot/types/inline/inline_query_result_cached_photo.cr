module TelegramBot
  class InlineQueryResultCachedPhoto < InlineQueryResult
    include JSON::Serializable

    property type : String = "photo"
    property id : String
    property photo_file_id : String
    property title : String?
    property description : String?
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property? show_caption_above_media : Bool?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @photo_file_id : String,
      *,
      @title : String? = nil,
      @description : String? = nil,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @show_caption_above_media : Bool? = nil,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @input_message_content : InputMessageContent? = nil,
    )
    end
  end
end
