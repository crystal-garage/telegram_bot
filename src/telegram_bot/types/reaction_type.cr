module TelegramBot
  abstract class ReactionType
    include JSON::Serializable

    use_json_discriminator "type", {
      custom_emoji: ReactionTypeCustomEmoji,
      emoji:        ReactionTypeEmoji,
      paid:         ReactionTypePaid,
    }

    property type : String
  end

  class ReactionTypeEmoji < ReactionType
    include JSON::Serializable

    property type : String = "emoji"
    property emoji : String

    def initialize(@emoji : String)
    end
  end

  class ReactionTypeCustomEmoji < ReactionType
    include JSON::Serializable

    property type : String = "custom_emoji"
    property custom_emoji_id : String

    def initialize(@custom_emoji_id : String)
    end
  end

  class ReactionTypePaid < ReactionType
    include JSON::Serializable

    property type : String = "paid"

    def initialize
    end
  end
end
