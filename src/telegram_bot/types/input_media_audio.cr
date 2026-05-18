module TelegramBot
  class InputMediaAudio < InputMedia
    include JSON::Serializable

    property type : String
    property media : String | AttachedFile
    property thumbnail : String | AttachedFile | Nil
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property duration : Int32?
    property performer : String?
    property title : String?

    def initialize(
      @media : String | AttachedFile,
      *,
      @thumbnail : String | AttachedFile | Nil = nil,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @duration : Int32? = nil,
      @performer : String? = nil,
      @title : String? = nil,
    )
      @type = "audio"
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@media, attachments)
      TelegramBot.collect_attachment(@thumbnail, attachments)
    end
  end
end
