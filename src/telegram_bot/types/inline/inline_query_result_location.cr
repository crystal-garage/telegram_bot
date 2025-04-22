module TelegramBot
  class InlineQueryResultLocation < InlineQueryResult
    include JSON::Serializable

    property type : String = "location"
    property id : String
    property latitude : Float64
    property longitude : Float64
    property title : String
    property live_period : Int32?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?
    property thumb_url : String?
    property thumb_width : Int32?
    property thumb_height : Int32?

    def initialize(
      @id : String,
      @latitude : Float64,
      @longitude : Float64,
      @title : String,
      *,
      @live_period = nil,
      @reply_markup = nil,
      @input_message_content = nil,
      @thumb_url = nil,
      @thumb_width = nil,
      @thumb_height = nil,
    )
    end
  end
end
