module TelegramBot
  class MessageEntity
    include JSON::Serializable

    property type : String
    property offset : Int32
    property length : Int32
    property url : String?
    property user : User?
    property language : String?
    property custom_emoji_id : String?
    property unix_time : Int32?
    property date_time_format : String?

    def initialize(
      @type : String,
      @offset : Int32,
      @length : Int32,
      *,
      @url = nil,
      @user = nil,
      @language : String? = nil,
      @custom_emoji_id = nil,
      @unix_time = nil,
      @date_time_format = nil,
    )
    end
  end
end
