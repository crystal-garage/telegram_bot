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
    property title : String?
    property caption : String?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?

    def initialize(
      @id : String,
      @mpeg4_url : String,
      *,
      @mpeg4_width = nil,
      @mpeg4_height = nil,
      @mpeg4_duration = nil,
      @thumbnail_url = nil,
      @title : String,
      @caption = nil,
      @reply_markup = nil,
      @input_message_content = nil,
    )
    end
  end
end
