module TelegramBot
  class ChatInviteLink
    include JSON::Serializable

    property invite_link : String
    property creator : User
    property? creates_join_request : Bool
    property? is_primary : Bool
    property? is_revoked : Bool
    property name : String?
    property expire_date : Int32?
    property member_limit : Int32?
    property pending_join_request_count : Int32?
    property subscription_period : Int32?
    property subscription_price : Int32?
  end
end
