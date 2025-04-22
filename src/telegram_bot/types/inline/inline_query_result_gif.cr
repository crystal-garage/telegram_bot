module TelegramBot
  class InlineQueryResultGif < InlineQueryResult
    include JSON::Serializable

    property type : String = "gif"
    property id : String
    property gif_url : String
    property gif_width : Int32?
    property gif_height : Int32?
    property gif_duration : Int32?
    property thumb_url : String
    property thumb_mime_type : String?
    property title : String?
    property caption : String?
    property parse_mode : String?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @gif_url : String,
      *,
      @gif_width = nil,
      @gif_height = nil,
      @gif_duration = nil,
      @thumb_url : String,
      @thumb_mime_type = nil,
      @title = nil,
      @caption = nil,
      @parse_mode = nil,
      @reply_markup = nil,
      @input_message_content = nil,
    )
    end
  end
end
