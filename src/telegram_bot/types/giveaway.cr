module TelegramBot
  class GiveawayCreated
    include JSON::Serializable

    property prize_star_count : Int32?
  end

  class Giveaway
    include JSON::Serializable

    property chats : Array(Chat)
    property winners_selection_date : Int32
    property winner_count : Int32
    property? only_new_members : Bool?
    property? has_public_winners : Bool?
    property prize_description : String?
    property country_codes : Array(String)?
    property prize_star_count : Int32?
    property premium_subscription_month_count : Int32?
  end

  class GiveawayWinners
    include JSON::Serializable

    property chat : Chat
    property giveaway_message_id : Int32
    property winners_selection_date : Int32
    property winner_count : Int32
    property winners : Array(User)
    property additional_chat_count : Int32?
    property prize_star_count : Int32?
    property premium_subscription_month_count : Int32?
    property unclaimed_prize_count : Int32?
    property? only_new_members : Bool?
    property? was_refunded : Bool?
    property prize_description : String?
  end

  class GiveawayCompleted
    include JSON::Serializable

    property winner_count : Int32
    property unclaimed_prize_count : Int32?
    property giveaway_message : Message?
    property? is_star_giveaway : Bool?
  end
end
