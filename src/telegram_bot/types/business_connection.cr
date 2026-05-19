module TelegramBot
  class BusinessConnection
    include JSON::Serializable

    property id : String
    property user : User
    property user_chat_id : Int64
    property date : Int32
    property rights : BusinessBotRights?
    property? is_enabled : Bool
  end
end
