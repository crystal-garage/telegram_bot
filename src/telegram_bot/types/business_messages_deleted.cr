module TelegramBot
  class BusinessMessagesDeleted
    include JSON::Serializable

    property business_connection_id : String?
    property chat : Chat?
    property message_ids : Array(Int32)?
  end
end
