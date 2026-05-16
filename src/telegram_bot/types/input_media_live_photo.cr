module TelegramBot
  class InputMediaLivePhoto < InputMedia
    include JSON::Serializable

    property type : String
    property media : String

    def initialize(@media : String)
      @type = "live_photo"
    end
  end
end
