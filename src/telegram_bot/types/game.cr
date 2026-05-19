module TelegramBot
  class Game
    include JSON::Serializable

    property title : String
    property description : String
    property photo : Array(PhotoSize)
    property text : String?
    property text_entities : Array(MessageEntity)?
    property animation : Animation?
  end
end
