module TelegramBot
  class Audio
    include JSON::Serializable

    property file_id : String
    property file_unique_id : String
    property duration : Int32
    property performer : String?
    property title : String?
    property mime_type : String?
    property file_size : Int64?
  end
end
