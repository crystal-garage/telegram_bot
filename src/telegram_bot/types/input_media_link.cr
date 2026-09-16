module TelegramBot
  class InputMediaLink < InputMedia
    include JSON::Serializable

    property type : String = "link"
    property url : String

    def initialize(
      @url : String,
    )
    end
  end
end
