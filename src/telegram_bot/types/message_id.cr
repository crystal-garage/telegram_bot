module TelegramBot
  class MessageId
    include JSON::Serializable

    property message_id : Int32
  end
end
