module TelegramBot
  class ManagedBotUpdated
    include JSON::Serializable

    property bot : User?
    property manager_bot : User?
    property user : User?
    property date : Int32?
    property old_token : String?
    property new_token : String?
  end

  class ManagedBotCreated
    include JSON::Serializable

    property user : User
    property token : String
  end
end
