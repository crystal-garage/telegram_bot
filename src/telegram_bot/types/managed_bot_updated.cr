module TelegramBot
  class ManagedBotUpdated
    include JSON::Serializable

    property user : User
    property bot : User
  end

  class ManagedBotCreated
    include JSON::Serializable

    property bot : User
    property token : String
  end
end
