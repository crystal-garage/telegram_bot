module TelegramBot
  class ReactionType
    include JSON::Serializable

    property type : String
    property emoji : String?
    property custom_emoji_id : String?
  end

  class ReactionTypeEmoji < ReactionType
    def initialize(@emoji : String)
      @type = "emoji"
      @custom_emoji_id = nil
    end
  end

  class ReactionTypeCustomEmoji < ReactionType
    def initialize(@custom_emoji_id : String)
      @type = "custom_emoji"
      @emoji = nil
    end
  end

  class ReactionTypePaid < ReactionType
    def initialize
      @type = "paid"
      @emoji = nil
      @custom_emoji_id = nil
    end
  end
end
