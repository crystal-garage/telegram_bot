module TelegramBot
  class ChatBoost
    include JSON::Serializable

    property boost_id : String
    property add_date : Int32
    property expiration_date : Int32
    property source : ChatBoostSource
  end

  abstract class ChatBoostSource
    include JSON::Serializable

    use_json_discriminator "source", {
      gift_code: ChatBoostSourceGiftCode,
      giveaway:  ChatBoostSourceGiveaway,
      premium:   ChatBoostSourcePremium,
    }

    property source : String
  end

  class ChatBoostSourcePremium < ChatBoostSource
    include JSON::Serializable

    property source : String
    property user : User
  end

  class ChatBoostSourceGiftCode < ChatBoostSource
    include JSON::Serializable

    property source : String
    property user : User
  end

  class ChatBoostSourceGiveaway < ChatBoostSource
    include JSON::Serializable

    property source : String
    property giveaway_message_id : Int32
    property user : User?
    property prize_star_count : Int64?
    property? is_unclaimed : Bool?
  end

  class ChatBoostUpdated
    include JSON::Serializable

    property chat : Chat
    property boost : ChatBoost
  end

  class ChatBoostRemoved
    include JSON::Serializable

    property chat : Chat
    property boost_id : String
    property remove_date : Int32
    property source : ChatBoostSource
  end

  class UserChatBoosts
    include JSON::Serializable

    property boosts : Array(ChatBoost)
  end
end
