module TelegramBot
  class InputMediaLocation < InputMedia
    include JSON::Serializable

    property type : String
    property latitude : Float64
    property longitude : Float64
    property horizontal_accuracy : Float64?

    def initialize(
      @latitude : Float64,
      @longitude : Float64,
      *,
      @horizontal_accuracy : Float64? = nil,
    )
      @type = "location"
    end
  end
end
