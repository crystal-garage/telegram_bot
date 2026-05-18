module TelegramBot
  class InputMediaSticker < InputMedia
    include JSON::Serializable

    property type : String
    property media : String | AttachedFile

    def initialize(@media : String | AttachedFile)
      @type = "sticker"
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@media, attachments)
    end
  end
end
