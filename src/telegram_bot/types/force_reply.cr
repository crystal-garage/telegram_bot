module TelegramBot
  class ForceReply
    include JSON::Serializable

    property? force_reply : Bool = true
    property? selective : Bool?

    def initialize(@selective : Bool? = nil)
    end
  end
end
