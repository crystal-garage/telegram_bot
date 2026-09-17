module TelegramBot
  class KeyboardButtonPollType
    include JSON::Serializable

    property type : String?

    def initialize(@type : String? = nil)
    end
  end
end
