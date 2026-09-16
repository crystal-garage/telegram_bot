module TelegramBot
  class Community
    include JSON::Serializable

    property id : Int64
    property name : String

    def initialize(
      @id : Int64,
      @name : String,
    )
    end
  end

  class CommunityChatAdded
    include JSON::Serializable

    property community : Community

    def initialize(
      @community : Community,
    )
    end
  end

  class CommunityChatRemoved
    include JSON::Serializable

    def initialize
    end
  end

  class CommunityChatJoined
    include JSON::Serializable

    property community : Community

    def initialize(
      @community : Community,
    )
    end
  end
end
