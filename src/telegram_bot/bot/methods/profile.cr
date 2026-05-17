module TelegramBot
  class Bot
    # Returns the bot's command list.
    #
    # See: <https://core.telegram.org/bots/api#getmycommands>
    def get_my_commands(
      scope : BotCommandScope? = nil,
      language_code : String? = nil,
    ) : Array(BotCommand)
      res = def_force_request(
        "getMyCommands",
        scope,
        language_code
      )
      res = res.not_nil!.as_a

      res.each_with_object([] of BotCommand) { |c, commands| commands << BotCommand.from_json(c.to_json) }
    end

    # Sets the bot's command list.
    #
    # See: <https://core.telegram.org/bots/api#setmycommands>
    def set_my_commands(
      commands : Array(BotCommand),
      scope : BotCommandScope? = nil,
      language_code : String? = nil,
    )
      res = def_request(
        "setMyCommands",
        commands,
        scope,
        language_code
      )

      res.as_bool if res
    end

    # Deletes the bot's command list.
    #
    # See: <https://core.telegram.org/bots/api#deletemycommands>
    def delete_my_commands(
      scope : BotCommandScope? = nil,
      language_code : String? = nil,
    )
      res = def_force_request(
        "deleteMyCommands",
        scope,
        language_code
      )

      res.as_bool if res
    end

    # Sets the bot's name.
    #
    # See: <https://core.telegram.org/bots/api#setmyname>
    def set_my_name(
      name : String? = nil,
      language_code : String? = nil,
    )
      res = def_force_request(
        "setMyName",
        name,
        language_code
      )

      res.as_bool if res
    end

    # Returns the bot's name.
    #
    # See: <https://core.telegram.org/bots/api#getmyname>
    def get_my_name(
      language_code : String? = nil,
    ) : BotName
      res = def_force_request(
        "getMyName",
        language_code
      )

      BotName.from_json(res.to_json)
    end

    # Sets the bot's description.
    #
    # See: <https://core.telegram.org/bots/api#setmydescription>
    def set_my_description(
      description : String? = nil,
      language_code : String? = nil,
    )
      res = def_force_request(
        "setMyDescription",
        description,
        language_code
      )

      res.as_bool if res
    end

    # Returns the bot's description.
    #
    # See: <https://core.telegram.org/bots/api#getmydescription>
    def get_my_description(
      language_code : String? = nil,
    ) : BotDescription
      res = def_force_request(
        "getMyDescription",
        language_code
      )

      BotDescription.from_json(res.to_json)
    end

    # Sets the bot's short description.
    #
    # See: <https://core.telegram.org/bots/api#setmyshortdescription>
    def set_my_short_description(
      short_description : String? = nil,
      language_code : String? = nil,
    )
      res = def_force_request(
        "setMyShortDescription",
        short_description,
        language_code
      )

      res.as_bool if res
    end

    # Returns the bot's short description.
    #
    # See: <https://core.telegram.org/bots/api#getmyshortdescription>
    def get_my_short_description(
      language_code : String? = nil,
    ) : BotShortDescription
      res = def_force_request(
        "getMyShortDescription",
        language_code
      )

      BotShortDescription.from_json(res.to_json)
    end

    # Sets the bot's profile photo.
    #
    # See: <https://core.telegram.org/bots/api#setmyprofilephoto>
    def set_my_profile_photo(
      photo : InputProfilePhoto,
    )
      res = def_force_request(
        "setMyProfilePhoto",
        photo
      )

      res.as_bool if res
    end

    # Removes the bot's profile photo.
    #
    # See: <https://core.telegram.org/bots/api#removemyprofilephoto>
    def remove_my_profile_photo
      res = request("removeMyProfilePhoto", force_http: true)

      res.as_bool if res
    end

    # Sets the bot's menu button in a private chat or globally.
    #
    # See: <https://core.telegram.org/bots/api#setchatmenubutton>
    def set_chat_menu_button(
      chat_id : Int? = nil,
      menu_button : MenuButton? = nil,
    )
      res = def_force_request(
        "setChatMenuButton",
        chat_id,
        menu_button
      )

      res.as_bool if res
    end

    # Returns the bot's menu button in a private chat or globally.
    #
    # See: <https://core.telegram.org/bots/api#getchatmenubutton>
    def get_chat_menu_button(
      chat_id : Int? = nil,
    ) : MenuButton
      res = def_force_request(
        "getChatMenuButton",
        chat_id
      )

      MenuButton.from_json(res.to_json)
    end

    # Verifies a user on behalf of the bot's organization.
    #
    # See: <https://core.telegram.org/bots/api#verifyuser>
    def verify_user(
      user_id : Int,
      custom_description : String? = nil,
    )
      res = def_force_request(
        "verifyUser",
        user_id,
        custom_description
      )

      res.as_bool if res
    end

    # Verifies a chat on behalf of the bot's organization.
    #
    # See: <https://core.telegram.org/bots/api#verifychat>
    def verify_chat(
      chat_id : Int | String,
      custom_description : String? = nil,
    )
      res = def_force_request(
        "verifyChat",
        chat_id,
        custom_description
      )

      res.as_bool if res
    end

    # Removes verification from a user.
    #
    # See: <https://core.telegram.org/bots/api#removeuserverification>
    def remove_user_verification(
      user_id : Int,
    )
      res = def_force_request(
        "removeUserVerification",
        user_id
      )

      res.as_bool if res
    end

    # Removes verification from a chat.
    #
    # See: <https://core.telegram.org/bots/api#removechatverification>
    def remove_chat_verification(
      chat_id : Int | String,
    )
      res = def_force_request(
        "removeChatVerification",
        chat_id
      )

      res.as_bool if res
    end

    # Sets the bot's default administrator rights.
    #
    # See: <https://core.telegram.org/bots/api#setmydefaultadministratorrights>
    def set_my_default_administrator_rights(
      rights : ChatAdministratorRights? = nil,
      for_channels : Bool? = nil,
    )
      res = def_force_request(
        "setMyDefaultAdministratorRights",
        rights,
        for_channels
      )

      res.as_bool if res
    end

    # Returns the bot's default administrator rights.
    #
    # See: <https://core.telegram.org/bots/api#getmydefaultadministratorrights>
    def get_my_default_administrator_rights(
      for_channels : Bool? = nil,
    ) : ChatAdministratorRights
      res = def_force_request(
        "getMyDefaultAdministratorRights",
        for_channels
      )

      ChatAdministratorRights.from_json(res.to_json)
    end
  end
end
