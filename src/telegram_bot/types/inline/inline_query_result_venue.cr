module TelegramBot
  class InlineQueryResultVenue < InlineQueryResult
    include JSON::Serializable

    property type : String = "venue"
    property id : String
    property latitude : Float64
    property longitude : Float64
    property title : String
    property address : String
    property foursquare_id : String?
    property foursquare_type : String?
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
      @address : String,
      *,
      @foursquare_id = nil,
      @foursquare_type = nil,
      @reply_markup = nil,
      @input_message_content = nil,
      @thumb_url = nil,
      @thumb_width = nil,
      @thumb_height = nil,
    )
    end
  end
end
