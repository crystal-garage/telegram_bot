module TelegramBot
  class KeyboardButtonRequestUsers
    include JSON::Serializable

    property request_id : Int32
    property? user_is_bot : Bool?
    property? user_is_premium : Bool?
    property max_quantity : Int32?
    property? request_name : Bool?
    property? request_username : Bool?
    property? request_photo : Bool?

    def initialize(
      @request_id : Int32,
      *,
      @user_is_bot = nil,
      @user_is_premium = nil,
      @max_quantity : Int32? = nil,
      @request_name = nil,
      @request_username = nil,
      @request_photo = nil,
    )
    end
  end
end
