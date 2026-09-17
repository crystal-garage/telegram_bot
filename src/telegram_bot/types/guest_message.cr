module TelegramBot
  class SentGuestMessage
    include JSON::Serializable

    property inline_message_id : String
  end
end
