module TelegramBot
  class CallbackQuery
    include JSON::Serializable

    property id : String
    property from : User
    property message : MaybeInaccessibleMessage?
    property inline_message_id : String?
    property chat_instance : String
    property data : String?
    property game_short_name : String?
  end
end
