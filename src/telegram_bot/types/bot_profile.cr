module TelegramBot
  class BotName
    include JSON::Serializable

    property name : String
  end

  class BotDescription
    include JSON::Serializable

    property description : String
  end

  class BotShortDescription
    include JSON::Serializable

    property short_description : String
  end
end
