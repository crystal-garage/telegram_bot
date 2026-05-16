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
      commands = Array(BotCommand).new
      res.each { |command| commands << BotCommand.from_json(command.to_json) }

      commands
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
