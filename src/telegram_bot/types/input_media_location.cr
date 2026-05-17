module TelegramBot
  class InputMediaLocation < InputMedia
    include JSON::Serializable

    property type : String
    property latitude : Float64
    property longitude : Float64
    property horizontal_accuracy : Float64?
    property live_period : Int32?
    property heading : Int32?
    property proximity_alert_radius : Int32?

    def initialize(
      @latitude : Float64,
      @longitude : Float64,
      *,
      @horizontal_accuracy : Float64? = nil,
      @live_period : Int32? = nil,
      @heading : Int32? = nil,
      @proximity_alert_radius : Int32? = nil,
    )
      @type = "location"
    end
  end
end
