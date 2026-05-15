module TelegramBot
  class ChatJoinRequest
    include JSON::Serializable

    property chat : Chat?
    property from : User?
    property user_chat_id : Int64?
    property date : Int32?
    property bio : String?
    property invite_link : JSON::Any?
  end
end
