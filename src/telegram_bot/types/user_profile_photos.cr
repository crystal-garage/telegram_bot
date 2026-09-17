module TelegramBot
  class UserProfilePhoto
    include JSON::Serializable

    property total_count : Int32
    property photos : Array(Array(PhotoSize))
  end
end
