module TelegramBot
  class InputMediaDocument < InputMedia
    include JSON::Serializable

    property type : String
    property media : String
    property thumbnail : String?
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property? disable_content_type_detection : Bool?

    def initialize(
      @media : String,
      *,
      @thumbnail : String? = nil,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @disable_content_type_detection : Bool? = nil,
    )
      @type = "document"
    end
  end
end
