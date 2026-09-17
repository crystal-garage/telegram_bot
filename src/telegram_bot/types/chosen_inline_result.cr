module TelegramBot
  class ChosenInlineResult
    include JSON::Serializable

    property result_id : String
    property from : User
    property location : Location?
    property inline_message_id : String?
    property query : String
  end
end
