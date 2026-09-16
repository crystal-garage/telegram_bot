module TelegramBot
  class InputMediaVoiceNote < InputMedia
    include JSON::Serializable

    property type : String = "voice_note"
    property media : String | AttachedFile
    property caption : String?
    property parse_mode : String?
    property caption_entities : Array(MessageEntity)?
    property duration : Int32?

    def initialize(
      @media : String | AttachedFile,
      *,
      @caption : String? = nil,
      @parse_mode : String? = nil,
      @caption_entities : Array(MessageEntity)? = nil,
      @duration : Int32? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@media, attachments)
    end
  end
end
