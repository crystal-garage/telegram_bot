module TelegramBot
  class ResponseParameters
    include JSON::Serializable

    property migrate_to_chat_id : Int64?
    property retry_after : Int32?
  end
end
