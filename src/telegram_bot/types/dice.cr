module TelegramBot
  class Dice
    include JSON::Serializable

    property emoji : String
    property value : Int32
  end
end
