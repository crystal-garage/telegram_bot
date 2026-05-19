module TelegramBot
  class InlineQuery
    include JSON::Serializable

    property id : String
    property from : User
    property location : Location?
    property query : String
    property offset : String
    property chat_type : String?
  end
end
