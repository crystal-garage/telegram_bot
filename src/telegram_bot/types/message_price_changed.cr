module TelegramBot
  class PaidMessagePriceChanged
    include JSON::Serializable

    property paid_message_star_count : Int32
  end

  class DirectMessagePriceChanged
    include JSON::Serializable

    property? are_direct_messages_enabled : Bool
    property direct_message_star_count : Int32?
  end
end
