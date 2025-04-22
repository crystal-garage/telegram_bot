module TelegramBot
  class PhotoSize
    include JSON::Serializable

    property file_id : String
    property file_unique_id : String
    property width : Int32
    property height : Int32
    property file_size : Int32?

    def initialize(
      @file_id : String,
      @file_unique_id : String,
      @width : Int32,
      @height : Int32,
      *,
      @file_size = nil,
    )
    end
  end
end
