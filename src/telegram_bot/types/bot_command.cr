module TelegramBot
  class BotCommand
    include JSON::Serializable

    property command : String
    property description : String

    def initialize(@command : String, @description : String)
    end
  end
end
