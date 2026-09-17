module TelegramBot
  class InputMediaVideo < InputMedia
    include JSON::Serializable

    property type : String
    property media : String | AttachedFile
    property thumbnail : String | AttachedFile?
    property cover : String | AttachedFile?
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
      @media : String | AttachedFile,
      *,
      @thumbnail : String | AttachedFile? = nil,
      @cover : String | AttachedFile? = nil,
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

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@media, attachments)
      TelegramBot.collect_attachment(@thumbnail, attachments)
      TelegramBot.collect_attachment(@cover, attachments)
    end
  end
end
