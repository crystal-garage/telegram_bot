module TelegramBot
  class VideoQuality
    include JSON::Serializable

    property file_id : String
    property file_unique_id : String
    property width : Int32
    property height : Int32
    property codec : String
    property file_size : Int64?
  end

  class Video
    include JSON::Serializable

    property file_id : String
    property file_unique_id : String
    property width : Int32
    property height : Int32
    property duration : Int32
    property thumbnail : PhotoSize?
    property cover : Array(PhotoSize)?
    property start_timestamp : Int32?
    property qualities : Array(VideoQuality)?
    property file_name : String?
    property mime_type : String?
    property file_size : Int64?
  end
end
