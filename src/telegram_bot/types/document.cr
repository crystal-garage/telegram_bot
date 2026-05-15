module TelegramBot
  class Document
    include JSON::Serializable

    property file_id : String
    property thumbnail : PhotoSize?
    property file_name : String?
    property mime_type : String?
    property file_size : Int32?
  end
end
