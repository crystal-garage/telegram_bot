module TelegramBot
  class ReplyKeyboardRemove
    include JSON::Serializable

    property? remove_keyboard : Bool = true
    property? selective : Bool?

    def initialize(@selective = nil)
    end
  end
end
