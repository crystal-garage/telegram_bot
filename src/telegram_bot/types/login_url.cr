module TelegramBot
  class LoginUrl
    include JSON::Serializable

    property url : String
    property forward_text : String?
    property bot_username : String?
    property? request_write_access : Bool?

    def initialize(
      @url : String,
      *,
      @forward_text : String? = nil,
      @bot_username : String? = nil,
      @request_write_access = nil,
    )
    end
  end
end
