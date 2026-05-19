module TelegramBot
  class SwitchInlineQueryChosenChat
    include JSON::Serializable

    property query : String?
    property? allow_user_chats : Bool?
    property? allow_bot_chats : Bool?
    property? allow_group_chats : Bool?
    property? allow_channel_chats : Bool?

    def initialize(
      *,
      @query : String? = nil,
      @allow_user_chats = nil,
      @allow_bot_chats = nil,
      @allow_group_chats = nil,
      @allow_channel_chats = nil,
    )
    end
  end
end
