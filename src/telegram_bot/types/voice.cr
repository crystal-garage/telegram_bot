module TelegramBot
  class Voice
    include JSON::Serializable

    property file_id : String
    property file_unique_id : String
    property duration : Int32
    property mime_type : String?
    property file_size : Int64?
  end
end
