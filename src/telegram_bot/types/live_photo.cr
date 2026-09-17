module TelegramBot
  class LivePhoto
    include JSON::Serializable

    property photo : Array(PhotoSize)?
    property file_id : String
    property file_unique_id : String
    property width : Int32
    property height : Int32
    property duration : Int32
    property mime_type : String?
    property file_size : Int64?
  end
end
