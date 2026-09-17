module TelegramBot
  abstract class BotCommandScope
    def to_json(json : JSON::Builder)
      raise "BotCommandScope subclasses must implement JSON serialization"
    end
  end

  class BotCommandScopeDefault < BotCommandScope
    include JSON::Serializable

    property type : String = "default"

    def initialize
    end
  end

  class BotCommandScopeAllPrivateChats < BotCommandScope
    include JSON::Serializable

    property type : String = "all_private_chats"

    def initialize
    end
  end

  class BotCommandScopeAllGroupChats < BotCommandScope
    include JSON::Serializable

    property type : String = "all_group_chats"

    def initialize
    end
  end

  class BotCommandScopeAllChatAdministrators < BotCommandScope
    include JSON::Serializable

    property type : String = "all_chat_administrators"

    def initialize
    end
  end

  class BotCommandScopeChat < BotCommandScope
    include JSON::Serializable

    property type : String = "chat"
    property chat_id : Int32 | Int64 | String

    def initialize(@chat_id : Int32 | Int64 | String)
    end
  end

  class BotCommandScopeChatAdministrators < BotCommandScope
    include JSON::Serializable

    property type : String = "chat_administrators"
    property chat_id : Int32 | Int64 | String

    def initialize(@chat_id : Int32 | Int64 | String)
    end
  end

  class BotCommandScopeChatMember < BotCommandScope
    include JSON::Serializable

    property type : String = "chat_member"
    property chat_id : Int32 | Int64 | String
    property user_id : Int64

    def initialize(@chat_id : Int32 | Int64 | String, user_id : Int32 | Int64)
      @user_id = user_id.to_i64
    end
  end
end
