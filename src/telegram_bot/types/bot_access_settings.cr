module TelegramBot
  class BotAccessSettings
    include JSON::Serializable

    property? is_access_restricted : Bool
    property added_users : Array(User)?
  end
end
