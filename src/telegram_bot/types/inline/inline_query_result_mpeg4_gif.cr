module TelegramBot
  class InlineQueryResultMpeg4Gif < InlineQueryResult
    include JSON::Serializable

    property type : String = "mpeg4_gif"
    property id : String
    property mpeg4_url : String
    property mpeg4_width : Int32?
    property mpeg4_height : Int32?
    property mpeg4_duration : Int32?
    property thumbnail_url : String
    property thumbnail_mime_type : String?
    property title : String?
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property? show_caption_above_media : Bool?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @mpeg4_url : String,
      *,
      @mpeg4_width : Int32? = nil,
      @mpeg4_height : Int32? = nil,
      @mpeg4_duration : Int32? = nil,
      @thumbnail_url : String,
      @thumbnail_mime_type : String? = nil,
      @title : String? = nil,
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
