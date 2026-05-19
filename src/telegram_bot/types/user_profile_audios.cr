module TelegramBot
  class UserProfileAudios
    include JSON::Serializable

    property total_count : Int32
    property audios : Array(Audio)
  end
end
