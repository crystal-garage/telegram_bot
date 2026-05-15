module TelegramBot
  class MessageReactionUpdated
    include JSON::Serializable

    property chat : Chat?
    property message_id : Int32?
    property user : User?
    property actor_chat : Chat?
    property date : Int32?
    property old_reaction : Array(JSON::Any)?
    property new_reaction : Array(JSON::Any)?
  end

  class ReactionCount
    include JSON::Serializable

    property type : JSON::Any?
    property total_count : Int32?
  end

  class MessageReactionCountUpdated
    include JSON::Serializable

    property chat : Chat?
    property message_id : Int32?
    property date : Int32?
    property reactions : Array(ReactionCount)?
  end
end
