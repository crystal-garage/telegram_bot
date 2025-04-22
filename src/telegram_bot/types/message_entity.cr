module TelegramBot
  class MessageEntity
    include JSON::Serializable

    property type : String
    property offset : Int32
    property length : Int32
    property url : String?
    property user : User?
    property language : User?

    def initialize(
      @type : String,
      @offset : Int32,
      @length : Int32,
      *,
      @url = nil,
      @user = nil,
      @language = nil,
    )
    end
  end
end
