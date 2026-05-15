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
      @caption = nil,
      @parse_mode = nil,
      @video_width = nil,
      @video_height = nil,
      @video_duration = nil,
      @description = nil,
      @reply_markup = nil,
      @input_message_content = nil,
    )
    end
  end
end
