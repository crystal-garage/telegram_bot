module TelegramBot
  class InlineQueryResultLocation < InlineQueryResult
    include JSON::Serializable

    property type : String = "location"
    property id : String
    property latitude : Float64
    property longitude : Float64
    property title : String
    property horizontal_accuracy : Float64?
    property live_period : Int32?
    property heading : Int32?
    property proximity_alert_radius : Int32?
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
      *,
      @horizontal_accuracy : Float64? = nil,
      @live_period : Int32? = nil,
      @heading : Int32? = nil,
      @proximity_alert_radius : Int32? = nil,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @input_message_content : InputMessageContent? = nil,
      @thumbnail_url : String? = nil,
      @thumbnail_width : Int32? = nil,
      @thumbnail_height : Int32? = nil,
    )
    end
  end
end
