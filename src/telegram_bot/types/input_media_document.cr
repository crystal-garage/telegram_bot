module TelegramBot
  class InputMediaDocument < InputMedia
    include JSON::Serializable

    property type : String
    property media : String | AttachedFile
    property thumbnail : String | AttachedFile | Nil
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property? disable_content_type_detection : Bool?

    def initialize(
      @media : String | AttachedFile,
      *,
      @thumbnail : String | AttachedFile | Nil = nil,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @disable_content_type_detection : Bool? = nil,
    )
      @type = "document"
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@media, attachments)
      TelegramBot.collect_attachment(@thumbnail, attachments)
    end
  end
end
