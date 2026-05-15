module TelegramBot
  class MessageOrigin
    include JSON::Serializable

    property type : String
    property date : Int32
  end

  class MessageOriginUser < MessageOrigin
    property sender_user : User
  end

  class MessageOriginHiddenUser < MessageOrigin
    property sender_user_name : String
  end

  class MessageOriginChat < MessageOrigin
    property sender_chat : Chat
    property author_signature : String?
  end

  class MessageOriginChannel < MessageOrigin
    property chat : Chat
    property message_id : Int32
    property author_signature : String?
  end
end
