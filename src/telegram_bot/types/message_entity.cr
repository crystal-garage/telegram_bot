module TelegramBot
  class MessageEntity
    include JSON::Serializable

    property type : String
    property offset : Int32
    property length : Int32
    property url : String?
    property user : User?
    property language : String?

    def initialize(
      @type : String,
      @offset : Int32,
      @length : Int32,
      *,
      @url = nil,
      @user = nil,
      @language : String? = nil,
    )
    end
  end
end
