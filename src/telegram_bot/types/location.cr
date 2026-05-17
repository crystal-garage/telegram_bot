module TelegramBot
  class Location
    include JSON::Serializable

    property longitude : Float64
    property latitude : Float64
    property horizontal_accuracy : Float64?
    property live_period : Int32?
    property heading : Int32?
    property proximity_alert_radius : Int32?
  end
end
