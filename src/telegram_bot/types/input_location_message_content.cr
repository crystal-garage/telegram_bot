module TelegramBot
  class InputLocationMessageContent < InputMessageContent
    include JSON::Serializable

    property latitude : Float64
    property longitude : Float64
    property horizontal_accuracy : Float64?
    property live_period : Int32?
    property heading : Int32?
    property proximity_alert_radius : Int32?

    def initialize(
      @latitude : Float64,
      @longitude : Float64,
      @live_period : Int32? = nil,
    )
      @horizontal_accuracy = nil
      @heading = nil
      @proximity_alert_radius = nil
    end

    def initialize(
      @latitude : Float64,
      @longitude : Float64,
      *,
      @horizontal_accuracy : Float64? = nil,
      @live_period : Int32? = nil,
      @heading : Int32? = nil,
      @proximity_alert_radius : Int32? = nil,
    )
    end
  end
end
