module TelegramBot
  class InputMediaAudio < InputMedia
    include JSON::Serializable

    property type : String
    property media : String
    property thumbnail : String?
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property duration : Int32?
    property performer : String?
    property title : String?

    def initialize(
      @media : String,
      *,
      @thumbnail : String? = nil,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @duration : Int32? = nil,
      @performer : String? = nil,
      @title : String? = nil,
    )
      @type = "audio"
    end
  end
end
