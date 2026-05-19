module TelegramBot
  class GameHighScore
    include JSON::Serializable

    property position : Int32
    property user : User
    property score : Int32
  end
end
