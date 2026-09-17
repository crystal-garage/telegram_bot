module TelegramBot
  class Link
    include JSON::Serializable

    property url : String

    def initialize(
      @url : String,
    )
    end
  end
end
