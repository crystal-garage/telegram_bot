module TelegramBot
  class InputMediaVideo < InputMedia
    include JSON::Serializable

    property type : String
    property media : String
    property thumbnail : String?
    property cover : String?
    property start_timestamp : Int32?
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property? show_caption_above_media : Bool?
    property width : Int32?
    property height : Int32?
    property duration : Int32?
    property? supports_streaming : Bool?
    property? has_spoiler : Bool?

    def initialize(
      @media : String,
      *,
      @thumbnail : String? = nil,
      @cover : String? = nil,
      @start_timestamp : Int32? = nil,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @show_caption_above_media : Bool? = nil,
      @width : Int32? = nil,
      @height : Int32? = nil,
      @duration : Int32? = nil,
      @supports_streaming : Bool? = nil,
      @has_spoiler : Bool? = nil,
    )
      @type = "video"
    end
  end
end
