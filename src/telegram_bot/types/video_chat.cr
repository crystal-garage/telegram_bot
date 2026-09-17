module TelegramBot
  class VideoChatScheduled
    include JSON::Serializable

    property start_date : Int32
  end

  class VideoChatStarted
    include JSON::Serializable
  end

  class VideoChatEnded
    include JSON::Serializable

    property duration : Int32
  end

  class VideoChatParticipantsInvited
    include JSON::Serializable

    property users : Array(User)
  end
end
