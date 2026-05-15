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
    property thumbnail_url : String?
    property thumbnail_width : Int32?
    property thumbnail_height : Int32?

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
      @thumbnail_url = nil,
      @thumbnail_width = nil,
      @thumbnail_height = nil,
    )
    end
  end
end
