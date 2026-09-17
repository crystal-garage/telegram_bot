module TelegramBot
  class TextQuote
    include JSON::Serializable

    property text : String
    property entities : Array(MessageEntity)?
    property position : Int32
    property? is_manual : Bool?
  end
end
