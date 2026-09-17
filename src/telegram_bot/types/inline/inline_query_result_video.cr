module TelegramBot
  class InlineQueryResultVideo < InlineQueryResult
    include JSON::Serializable

    property type : String = "video"
    property id : String
    property video_url : String
    # Mime type of the content of video url, "text/html" or "video/mp4"
    property mime_type : String
    # URL of the thumbnail (jpeg only) for the video
    property thumbnail_url : String
    property title : String
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property? show_caption_above_media : Bool?
    property video_width : Int32?
    property video_height : Int32?
    property video_duration : Int32?
    property description : String?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @video_url : String,
      @mime_type : String,
      @thumbnail_url : String,
      @title : String,
      *,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @show_caption_above_media : Bool? = nil,
      @video_width : Int32? = nil,
      @video_height : Int32? = nil,
      @video_duration : Int32? = nil,
      @description : String? = nil,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @input_message_content : InputMessageContent? = nil,
    )
    end
  end
end
