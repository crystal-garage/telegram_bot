module TelegramBot
  class BotCommand
    include JSON::Serializable

    property command : String
    property description : String
    property? is_ephemeral : Bool?

    def initialize(@command : String, @description : String, *, @is_ephemeral : Bool? = nil)
    end
  end
end
