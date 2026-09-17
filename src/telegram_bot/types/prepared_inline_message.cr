module TelegramBot
  class PreparedInlineMessage
    include JSON::Serializable

    property id : String
    property expiration_date : Int32
  end

  class PreparedKeyboardButton
    include JSON::Serializable

    property id : String
  end
end
