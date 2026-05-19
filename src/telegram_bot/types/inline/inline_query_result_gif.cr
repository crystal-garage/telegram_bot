module TelegramBot
  class InlineQueryResultGif < InlineQueryResult
    include JSON::Serializable

    property type : String = "gif"
    property id : String
    property gif_url : String
    property gif_width : Int32?
    property gif_height : Int32?
    property gif_duration : Int32?
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
      @gif_url : String,
      *,
      @gif_width : Int32? = nil,
      @gif_height : Int32? = nil,
      @gif_duration : Int32? = nil,
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
