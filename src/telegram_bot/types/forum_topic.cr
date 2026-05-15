module TelegramBot
  class ForumTopic
    include JSON::Serializable

    property message_thread_id : Int32
    property name : String
    property icon_color : Int32
    property icon_custom_emoji_id : String?
  end

  class ForumTopicCreated
    include JSON::Serializable

    property name : String
    property icon_color : Int32
    property icon_custom_emoji_id : String?
    property? is_name_implicit : Bool?
  end

  class ForumTopicEdited
    include JSON::Serializable

    property name : String?
    property icon_custom_emoji_id : String?
  end

  class ForumTopicClosed
    include JSON::Serializable
  end

  class ForumTopicReopened
    include JSON::Serializable
  end

  class GeneralForumTopicHidden
    include JSON::Serializable
  end

  class GeneralForumTopicUnhidden
    include JSON::Serializable
  end
end
