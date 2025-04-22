module TelegramBot
  class InlineKeyboardButton
    include JSON::Serializable

    property text : String
    property url : String?
    property callback_data : String?
    property switch_inline_query : String?

    def initialize(
      @text : String,
      *,
      @url : String? = nil,
      @callback_data : String? = nil,
      @switch_inline_query : String? = nil,
    )
    end
  end
end
