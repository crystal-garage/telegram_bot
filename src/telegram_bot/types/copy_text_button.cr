module TelegramBot
  class CopyTextButton
    include JSON::Serializable

    property text : String

    def initialize(@text : String)
    end
  end
end
