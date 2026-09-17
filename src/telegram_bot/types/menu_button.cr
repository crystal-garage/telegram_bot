module TelegramBot
  abstract class MenuButton
    include JSON::Serializable

    use_json_discriminator "type", {
      commands: MenuButtonCommands,
      default:  MenuButtonDefault,
      web_app:  MenuButtonWebApp,
    }

    property type : String
  end

  class MenuButtonCommands < MenuButton
    include JSON::Serializable

    property type : String = "commands"

    def initialize
    end
  end

  class MenuButtonWebApp < MenuButton
    include JSON::Serializable

    property type : String = "web_app"
    property text : String
    property web_app : WebAppInfo

    def initialize(@text : String, @web_app : WebAppInfo)
    end
  end

  class MenuButtonDefault < MenuButton
    include JSON::Serializable

    property type : String = "default"

    def initialize
    end
  end
end
