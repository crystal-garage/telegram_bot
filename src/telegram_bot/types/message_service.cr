module TelegramBot
  class ChatOwnerLeft
    include JSON::Serializable

    property new_owner : User?
  end

  class ChatOwnerChanged
    include JSON::Serializable

    property new_owner : User
  end

  class MessageAutoDeleteTimerChanged
    include JSON::Serializable

    property message_auto_delete_time : Int32
  end

  class SharedUser
    include JSON::Serializable

    property user_id : Int64
    property first_name : String?
    property last_name : String?
    property username : String?
    property photo : Array(PhotoSize)?
  end

  class UsersShared
    include JSON::Serializable

    property request_id : Int32
    property users : Array(SharedUser)
  end

  class ChatShared
    include JSON::Serializable

    property request_id : Int32
    property chat_id : Int64
    property title : String?
    property username : String?
    property photo : Array(PhotoSize)?
  end

  class WriteAccessAllowed
    include JSON::Serializable

    property? from_request : Bool?
    property web_app_name : String?
    property? from_attachment_menu : Bool?
  end

  class ProximityAlertTriggered
    include JSON::Serializable

    property traveler : User
    property watcher : User
    property distance : Int32
  end

  class ChatBoostAdded
    include JSON::Serializable

    property boost_count : Int32
  end
end
