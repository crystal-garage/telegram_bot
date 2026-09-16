module TelegramBot
  class ChatJoinRequest
    include JSON::Serializable

    property query_id : String?

    property chat : Chat?
    property from : User?
    property user_chat_id : Int64?
    property date : Int32?
    property bio : String?
    property invite_link : ChatInviteLink?
  end
end
