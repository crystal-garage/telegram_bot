module TelegramBot
  class DirectMessagesTopic
    include JSON::Serializable

    property topic_id : Int64
  end
end
