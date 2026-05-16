module TelegramBot
  class MenuButton
    include JSON::Serializable

    property type : String
    property text : String?
    property web_app : WebAppInfo?
  end

  class MenuButtonCommands < MenuButton
    def initialize
      @type = "commands"
      @text = nil
      @web_app = nil
    end
  end

  class MenuButtonWebApp < MenuButton
    def initialize(@text : String, @web_app : WebAppInfo)
      @type = "web_app"
    end
  end

  class MenuButtonDefault < MenuButton
    def initialize
      @type = "default"
      @text = nil
      @web_app = nil
    end
  end
end
