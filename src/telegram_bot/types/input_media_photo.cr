module TelegramBot
  class InputMediaPhoto < InputMedia
    include JSON::Serializable

    property type : String
    property media : String | AttachedFile
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property? show_caption_above_media : Bool?
    property? has_spoiler : Bool?

    def initialize(
      @media : String | AttachedFile,
      *,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @show_caption_above_media : Bool? = nil,
      @has_spoiler : Bool? = nil,
    )
      @type = "photo"
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@media, attachments)
    end
  end
end
