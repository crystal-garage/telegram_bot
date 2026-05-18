module TelegramBot
  class InputMediaLivePhoto < InputMedia
    include JSON::Serializable

    property type : String
    property media : String
    property photo : String
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property? show_caption_above_media : Bool?
    property? has_spoiler : Bool?

    def initialize(
      @media : String,
      @photo : String,
      *,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @show_caption_above_media : Bool? = nil,
      @has_spoiler : Bool? = nil,
    )
      @type = "live_photo"
    end
  end
end
