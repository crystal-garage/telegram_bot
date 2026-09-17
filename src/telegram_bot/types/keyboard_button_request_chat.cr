module TelegramBot
  class KeyboardButtonRequestChat
    include JSON::Serializable

    property request_id : Int32
    property? chat_is_channel : Bool
    property? chat_is_forum : Bool?
    property? chat_has_username : Bool?
    property? chat_is_created : Bool?
    property user_administrator_rights : ChatAdministratorRights?
    property bot_administrator_rights : ChatAdministratorRights?
    property? bot_is_member : Bool?
    property? request_title : Bool?
    property? request_username : Bool?
    property? request_photo : Bool?

    def initialize(
      @request_id : Int32,
      @chat_is_channel : Bool,
      *,
      @chat_is_forum = nil,
      @chat_has_username = nil,
      @chat_is_created = nil,
      @user_administrator_rights : ChatAdministratorRights? = nil,
      @bot_administrator_rights : ChatAdministratorRights? = nil,
      @bot_is_member = nil,
      @request_title = nil,
      @request_username = nil,
      @request_photo = nil,
    )
    end
  end
end
