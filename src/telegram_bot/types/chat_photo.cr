module TelegramBot
  class ChatPhoto
    include JSON::Serializable

    property small_file_id : String
    property big_file_id : String
  end
end
