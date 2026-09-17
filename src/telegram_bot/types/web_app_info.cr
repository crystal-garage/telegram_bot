module TelegramBot
  class WebAppInfo
    include JSON::Serializable

    property url : String

    def initialize(@url : String)
    end
  end

  class WebAppData
    include JSON::Serializable

    property data : String
    property button_text : String
  end

  class SentWebAppMessage
    include JSON::Serializable

    property inline_message_id : String?
  end
end
