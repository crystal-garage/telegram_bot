module TelegramBot
  abstract class Bot
    def get_available_gifts : Gifts
      res = request(
        "getAvailableGifts",
        force_http: true
      )

      Gifts.from_json(res.to_json)
    end

    def send_gift(
      gift_id : String,
      user_id : Int? = nil,
      chat_id : Int | String? = nil,
      pay_for_upgrade : Bool? = nil,
      text : String? = nil,
      text_parse_mode : String? = nil,
      text_entities : Array(MessageEntity)? = nil,
    )
      res = def_force_request(
        "sendGift",
        user_id,
        chat_id,
        gift_id,
        pay_for_upgrade,
        text,
        text_parse_mode,
        text_entities
      )

      res.as_bool if res
    end

    def gift_premium_subscription(
      user_id : Int,
      month_count : Int,
      star_count : Int,
      text : String? = nil,
      text_parse_mode : String? = nil,
      text_entities : Array(MessageEntity)? = nil,
    )
      res = def_force_request(
        "giftPremiumSubscription",
        user_id,
        month_count,
        star_count,
        text,
        text_parse_mode,
        text_entities
      )

      res.as_bool if res
    end

    def answer_guest_query(
      guest_query_id : String,
      result : InlineQueryResult,
    ) : SentGuestMessage
      res = def_request(
        "answerGuestQuery",
        guest_query_id,
        result
      )

      SentGuestMessage.from_json(res.to_json)
    end

    def get_business_connection(
      business_connection_id : String,
    ) : BusinessConnection
      res = def_force_request(
        "getBusinessConnection",
        business_connection_id
      )

      BusinessConnection.from_json(res.to_json)
    end

    def read_business_message(
      business_connection_id : String,
      chat_id : Int | String,
      message_id : Int,
    )
      res = def_force_request(
        "readBusinessMessage",
        business_connection_id,
        chat_id,
        message_id
      )

      res.as_bool if res
    end

    def delete_business_messages(
      business_connection_id : String,
      message_ids : Array(Int32),
    )
      res = def_force_request(
        "deleteBusinessMessages",
        business_connection_id,
        message_ids
      )

      res.as_bool if res
    end

    def set_business_account_name(
      business_connection_id : String,
      first_name : String,
      last_name : String? = nil,
    )
      res = def_force_request(
        "setBusinessAccountName",
        business_connection_id,
        first_name,
        last_name
      )

      res.as_bool if res
    end

    def set_business_account_username(
      business_connection_id : String,
      username : String? = nil,
    )
      res = def_force_request(
        "setBusinessAccountUsername",
        business_connection_id,
        username
      )

      res.as_bool if res
    end

    def set_business_account_bio(
      business_connection_id : String,
      bio : String? = nil,
    )
      res = def_force_request(
        "setBusinessAccountBio",
        business_connection_id,
        bio
      )

      res.as_bool if res
    end

    def set_business_account_profile_photo(
      business_connection_id : String,
      photo : InputProfilePhoto,
      is_public : Bool? = nil,
    )
      res = def_force_request(
        "setBusinessAccountProfilePhoto",
        business_connection_id,
        photo,
        is_public
      )

      res.as_bool if res
    end

    def remove_business_account_profile_photo(
      business_connection_id : String,
      is_public : Bool? = nil,
    )
      res = def_force_request(
        "removeBusinessAccountProfilePhoto",
        business_connection_id,
        is_public
      )

      res.as_bool if res
    end

    def set_business_account_gift_settings(
      business_connection_id : String,
      show_gift_button : Bool,
      accepted_gift_types : AcceptedGiftTypes,
    )
      res = def_force_request(
        "setBusinessAccountGiftSettings",
        business_connection_id,
        show_gift_button,
        accepted_gift_types
      )

      res.as_bool if res
    end

    def get_managed_bot_token(
      user_id : Int,
    ) : String
      res = def_force_request(
        "getManagedBotToken",
        user_id
      )

      res.as_s
    end

    def replace_managed_bot_token(
      user_id : Int,
    ) : String
      res = def_force_request(
        "replaceManagedBotToken",
        user_id
      )

      res.as_s
    end

    def get_managed_bot_access_settings(
      user_id : Int,
    ) : BotAccessSettings
      res = def_force_request(
        "getManagedBotAccessSettings",
        user_id
      )

      BotAccessSettings.from_json(res.to_json)
    end

    def set_managed_bot_access_settings(
      user_id : Int,
      is_access_restricted : Bool,
      added_user_ids : Array(Int64)? = nil,
    )
      res = def_force_request(
        "setManagedBotAccessSettings",
        user_id,
        is_access_restricted,
        added_user_ids
      )

      res.as_bool if res
    end
  end
end
