module TelegramBot
  class Bot
    # Returns gifts that can be sent by the bot.
    #
    # See: <https://core.telegram.org/bots/api#getavailablegifts>
    def get_available_gifts : Gifts
      res = request(
        "getAvailableGifts",
        force_http: true
      )

      Gifts.from_json(res.to_json)
    end

    # Sends a gift to a user or chat.
    #
    # See: <https://core.telegram.org/bots/api#sendgift>
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

    # Gifts a Telegram Premium subscription to a user.
    #
    # See: <https://core.telegram.org/bots/api#giftpremiumsubscription>
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

    # Returns the Star balance of a managed business account.
    #
    # See: <https://core.telegram.org/bots/api#getbusinessaccountstarbalance>
    def get_business_account_star_balance(
      business_connection_id : String,
    ) : StarAmount
      res = def_force_request(
        "getBusinessAccountStarBalance",
        business_connection_id
      )

      StarAmount.from_json(res.to_json)
    end

    # Transfers Stars from a business account to the bot's balance.
    #
    # See: <https://core.telegram.org/bots/api#transferbusinessaccountstars>
    def transfer_business_account_stars(
      business_connection_id : String,
      star_count : Int,
    )
      res = def_force_request(
        "transferBusinessAccountStars",
        business_connection_id,
        star_count
      )

      res.as_bool if res
    end

    # Returns gifts owned by a managed business account.
    #
    # See: <https://core.telegram.org/bots/api#getbusinessaccountgifts>
    def get_business_account_gifts(
      business_connection_id : String,
      exclude_unsaved : Bool? = nil,
      exclude_saved : Bool? = nil,
      exclude_unlimited : Bool? = nil,
      exclude_limited_upgradable : Bool? = nil,
      exclude_limited_non_upgradable : Bool? = nil,
      exclude_from_blockchain : Bool? = nil,
      exclude_unique : Bool? = nil,
      sort_by_price : Bool? = nil,
      offset : String? = nil,
      limit : Int32? = nil,
    ) : OwnedGifts
      res = def_force_request(
        "getBusinessAccountGifts",
        business_connection_id,
        exclude_unsaved,
        exclude_saved,
        exclude_unlimited,
        exclude_limited_upgradable,
        exclude_limited_non_upgradable,
        exclude_from_blockchain,
        exclude_unique,
        sort_by_price,
        offset,
        limit
      )

      OwnedGifts.from_json(res.to_json)
    end

    # Returns gifts owned and hosted by a user.
    #
    # See: <https://core.telegram.org/bots/api#getusergifts>
    def get_user_gifts(
      user_id : Int,
      exclude_unlimited : Bool? = nil,
      exclude_limited_upgradable : Bool? = nil,
      exclude_limited_non_upgradable : Bool? = nil,
      exclude_from_blockchain : Bool? = nil,
      exclude_unique : Bool? = nil,
      sort_by_price : Bool? = nil,
      offset : String? = nil,
      limit : Int32? = nil,
    ) : OwnedGifts
      res = def_force_request(
        "getUserGifts",
        user_id,
        exclude_unlimited,
        exclude_limited_upgradable,
        exclude_limited_non_upgradable,
        exclude_from_blockchain,
        exclude_unique,
        sort_by_price,
        offset,
        limit
      )

      OwnedGifts.from_json(res.to_json)
    end

    # Returns gifts owned by a chat.
    #
    # See: <https://core.telegram.org/bots/api#getchatgifts>
    def get_chat_gifts(
      chat_id : Int | String,
      exclude_unsaved : Bool? = nil,
      exclude_saved : Bool? = nil,
      exclude_unlimited : Bool? = nil,
      exclude_limited_upgradable : Bool? = nil,
      exclude_limited_non_upgradable : Bool? = nil,
      exclude_from_blockchain : Bool? = nil,
      exclude_unique : Bool? = nil,
      sort_by_price : Bool? = nil,
      offset : String? = nil,
      limit : Int32? = nil,
    ) : OwnedGifts
      res = def_force_request(
        "getChatGifts",
        chat_id,
        exclude_unsaved,
        exclude_saved,
        exclude_unlimited,
        exclude_limited_upgradable,
        exclude_limited_non_upgradable,
        exclude_from_blockchain,
        exclude_unique,
        sort_by_price,
        offset,
        limit
      )

      OwnedGifts.from_json(res.to_json)
    end

    # Converts a regular gift owned by a business account to Stars.
    #
    # See: <https://core.telegram.org/bots/api#convertgifttostars>
    def convert_gift_to_stars(
      business_connection_id : String,
      owned_gift_id : String,
    )
      res = def_force_request(
        "convertGiftToStars",
        business_connection_id,
        owned_gift_id
      )

      res.as_bool if res
    end

    # Upgrades a regular gift owned by a business account to a unique gift.
    #
    # See: <https://core.telegram.org/bots/api#upgradegift>
    def upgrade_gift(
      business_connection_id : String,
      owned_gift_id : String,
      keep_original_details : Bool? = nil,
      star_count : Int? = nil,
    )
      res = def_force_request(
        "upgradeGift",
        business_connection_id,
        owned_gift_id,
        keep_original_details,
        star_count
      )

      res.as_bool if res
    end

    # Transfers a unique gift owned by a business account to another user.
    #
    # See: <https://core.telegram.org/bots/api#transfergift>
    def transfer_gift(
      business_connection_id : String,
      owned_gift_id : String,
      new_owner_chat_id : Int,
      star_count : Int? = nil,
    )
      res = def_force_request(
        "transferGift",
        business_connection_id,
        owned_gift_id,
        new_owner_chat_id,
        star_count
      )

      res.as_bool if res
    end

    # Posts a story on behalf of a managed business account.
    #
    # See: <https://core.telegram.org/bots/api#poststory>
    def post_story(
      business_connection_id : String,
      content : InputStoryContent,
      active_period : Int,
      caption : String? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      areas : Array(StoryArea)? = nil,
      post_to_chat_page : Bool? = nil,
      protect_content : Bool? = nil,
    ) : Story
      res = def_force_request(
        "postStory",
        business_connection_id,
        content,
        active_period,
        caption,
        parse_mode,
        caption_entities,
        areas,
        post_to_chat_page,
        protect_content
      )

      Story.from_json(res.to_json)
    end

    # Reposts a story on behalf of a managed business account.
    #
    # See: <https://core.telegram.org/bots/api#repoststory>
    def repost_story(
      business_connection_id : String,
      from_chat_id : Int,
      from_story_id : Int,
      active_period : Int,
      post_to_chat_page : Bool? = nil,
      protect_content : Bool? = nil,
    ) : Story
      res = def_force_request(
        "repostStory",
        business_connection_id,
        from_chat_id,
        from_story_id,
        active_period,
        post_to_chat_page,
        protect_content
      )

      Story.from_json(res.to_json)
    end

    # Edits a story posted on behalf of a managed business account.
    #
    # See: <https://core.telegram.org/bots/api#editstory>
    def edit_story(
      business_connection_id : String,
      story_id : Int,
      content : InputStoryContent,
      caption : String? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      areas : Array(StoryArea)? = nil,
    ) : Story
      res = def_force_request(
        "editStory",
        business_connection_id,
        story_id,
        content,
        caption,
        parse_mode,
        caption_entities,
        areas
      )

      Story.from_json(res.to_json)
    end

    # Deletes a story posted on behalf of a managed business account.
    #
    # See: <https://core.telegram.org/bots/api#deletestory>
    def delete_story(
      business_connection_id : String,
      story_id : Int,
    )
      res = def_force_request(
        "deleteStory",
        business_connection_id,
        story_id
      )

      res.as_bool if res
    end

    # Sends an answer to a guest query.
    #
    # See: <https://core.telegram.org/bots/api#answerguestquery>
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

    # Returns information about a business connection.
    #
    # See: <https://core.telegram.org/bots/api#getbusinessconnection>
    def get_business_connection(
      business_connection_id : String,
    ) : BusinessConnection
      res = def_force_request(
        "getBusinessConnection",
        business_connection_id
      )

      BusinessConnection.from_json(res.to_json)
    end

    # Marks a business message as read.
    #
    # See: <https://core.telegram.org/bots/api#readbusinessmessage>
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

    # Deletes messages on behalf of a business account.
    #
    # See: <https://core.telegram.org/bots/api#deletebusinessmessages>
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

    # Sets the name of a business account.
    #
    # See: <https://core.telegram.org/bots/api#setbusinessaccountname>
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

    # Sets the username of a business account.
    #
    # See: <https://core.telegram.org/bots/api#setbusinessaccountusername>
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

    # Sets the bio of a business account.
    #
    # See: <https://core.telegram.org/bots/api#setbusinessaccountbio>
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

    # Sets a business account profile photo.
    #
    # See: <https://core.telegram.org/bots/api#setbusinessaccountprofilephoto>
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

    # Removes a business account profile photo.
    #
    # See: <https://core.telegram.org/bots/api#removebusinessaccountprofilephoto>
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

    # Sets gift settings for a business account.
    #
    # See: <https://core.telegram.org/bots/api#setbusinessaccountgiftsettings>
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

    # Returns a token for a managed bot.
    #
    # See: <https://core.telegram.org/bots/api#getmanagedbottoken>
    def get_managed_bot_token(
      user_id : Int,
    ) : String
      res = def_force_request(
        "getManagedBotToken",
        user_id
      )

      res.as_s
    end

    # Replaces the token for a managed bot.
    #
    # See: <https://core.telegram.org/bots/api#replacemanagedbottoken>
    def replace_managed_bot_token(
      user_id : Int,
    ) : String
      res = def_force_request(
        "replaceManagedBotToken",
        user_id
      )

      res.as_s
    end

    # Returns access settings for a managed bot.
    #
    # See: <https://core.telegram.org/bots/api#getmanagedbotaccesssettings>
    def get_managed_bot_access_settings(
      user_id : Int,
    ) : BotAccessSettings
      res = def_force_request(
        "getManagedBotAccessSettings",
        user_id
      )

      BotAccessSettings.from_json(res.to_json)
    end

    # Sets access settings for a managed bot.
    #
    # See: <https://core.telegram.org/bots/api#setmanagedbotaccesssettings>
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
