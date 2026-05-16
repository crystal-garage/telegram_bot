module TelegramBot
  class ChatBoost
    include JSON::Serializable

    property boost_id : String?
    property add_date : Int32?
    property expiration_date : Int32?
    property source : JSON::Any?
  end

  class ChatBoostUpdated
    include JSON::Serializable

    property chat : Chat?
    property boost : ChatBoost?
  end

  class ChatBoostRemoved
    include JSON::Serializable

    property chat : Chat?
    property boost_id : String?
    property remove_date : Int32?
    property source : JSON::Any?
  end

  class UserChatBoosts
    include JSON::Serializable

    property boosts : Array(ChatBoost)
  end
end
