module TelegramBot
  class InputMediaAnimation < InputMedia
    include JSON::Serializable

    property type : String
    property media : String
    property thumbnail : String?
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property? show_caption_above_media : Bool?
    property width : Int32?
    property height : Int32?
    property duration : Int32?
    property? has_spoiler : Bool?

    def initialize(
      @media : String,
      *,
      @thumbnail : String? = nil,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @show_caption_above_media : Bool? = nil,
      @width : Int32? = nil,
      @height : Int32? = nil,
      @duration : Int32? = nil,
      @has_spoiler : Bool? = nil,
    )
      @type = "animation"
    end
  end
end
