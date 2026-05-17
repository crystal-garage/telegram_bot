module TelegramBot
  class ChatBoost
    include JSON::Serializable

    property boost_id : String?
    property add_date : Int32?
    property expiration_date : Int32?
    property source : ChatBoostSource?
  end

  class ChatBoostSource
    include JSON::Serializable

    property source : String
    property user : User?
    property prize_star_count : Int32?
    property giveaway_message_id : Int32?
    property? is_unclaimed : Bool?
  end

  class ChatBoostSourcePremium < ChatBoostSource
  end

  class ChatBoostSourceGiftCode < ChatBoostSource
  end

  class ChatBoostSourceGiveaway < ChatBoostSource
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
    property source : ChatBoostSource?
  end

  class UserChatBoosts
    include JSON::Serializable

    property boosts : Array(ChatBoost)
  end
end
