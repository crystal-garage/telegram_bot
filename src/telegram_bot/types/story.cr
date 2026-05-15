module TelegramBot
  class Story
    include JSON::Serializable

    property chat : Chat
    property id : Int32
  end
end
