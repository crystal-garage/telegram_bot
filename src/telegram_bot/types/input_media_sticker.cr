module TelegramBot
  class InputMediaSticker < InputMedia
    include JSON::Serializable

    property type : String
    property media : String

    def initialize(@media : String)
      @type = "sticker"
    end
  end
end
