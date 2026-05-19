module TelegramBot
  abstract class MessageOrigin
    include JSON::Serializable

    use_json_discriminator "type", {
      channel:     MessageOriginChannel,
      chat:        MessageOriginChat,
      hidden_user: MessageOriginHiddenUser,
      user:        MessageOriginUser,
    }

    property type : String
    property date : Int32
  end

  class MessageOriginUser < MessageOrigin
    include JSON::Serializable

    property sender_user : User
  end

  class MessageOriginHiddenUser < MessageOrigin
    include JSON::Serializable

    property sender_user_name : String
  end

  class MessageOriginChat < MessageOrigin
    include JSON::Serializable

    property sender_chat : Chat
    property author_signature : String?
  end

  class MessageOriginChannel < MessageOrigin
    include JSON::Serializable

    property chat : Chat
    property message_id : Int32
    property author_signature : String?
  end
end
