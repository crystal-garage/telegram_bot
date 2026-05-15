module TelegramBot
  class ChatMemberUpdated
    include JSON::Serializable

    property chat : Chat?
    property from : User?
    property date : Int32?
    property old_chat_member : ChatMember?
    property new_chat_member : ChatMember?
    property invite_link : JSON::Any?
    property? via_join_request : Bool?
    property? via_chat_folder_invite_link : Bool?
  end
end
