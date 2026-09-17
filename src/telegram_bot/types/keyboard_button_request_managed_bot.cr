module TelegramBot
  class KeyboardButtonRequestManagedBot
    include JSON::Serializable

    property request_id : Int32
    property suggested_name : String?
    property suggested_username : String?

    def initialize(
      @request_id : Int32,
      *,
      @suggested_name : String? = nil,
      @suggested_username : String? = nil,
    )
    end
  end
end
