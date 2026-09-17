module TelegramBot
  class MessageReactionUpdated
    include JSON::Serializable

    property chat : Chat
    property message_id : Int32
    property user : User?
    property actor_chat : Chat?
    property date : Int32
    property old_reaction : Array(ReactionType)
    property new_reaction : Array(ReactionType)
  end

  class ReactionCount
    include JSON::Serializable

    property type : ReactionType
    property total_count : Int32
  end

  class MessageReactionCountUpdated
    include JSON::Serializable

    property chat : Chat
    property message_id : Int32
    property date : Int32
    property reactions : Array(ReactionCount)
  end
end
