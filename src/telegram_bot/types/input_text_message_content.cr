module TelegramBot
  class InputTextMessageContent < InputMessageContent
    include JSON::Serializable

    property message_text : String
    property parse_mode : String?
    property? disable_web_page_preview : Bool?

    def initialize(
      @message_text : String,
      *,
      @parse_mode = nil,
      @disable_web_page_preview = nil,
    )
    end
  end
end
