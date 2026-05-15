module TelegramBot
  class InputVenueMessageContent < InputMessageContent
    include JSON::Serializable

    property latitude : Float64
    property longitude : Float64
    property title : String
    property address : String
    property foursquare_id : String?
    property foursquare_type : String?

    def initialize(
      @latitude : Float64,
      @longitude : Float64,
      @title : String,
      @address : String,
      *,
      @foursquare_id = nil,
      @foursquare_type = nil,
    )
    end
  end
end
