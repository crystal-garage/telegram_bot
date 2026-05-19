module TelegramBot
  class File
    include JSON::Serializable

    property file_id : String
    property file_unique_id : String
    property file_size : Int64?
    property file_path : String?
  end
end
