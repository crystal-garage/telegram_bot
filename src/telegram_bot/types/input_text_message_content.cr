module TelegramBot
  class InputTextMessageContent < InputMessageContent
    include JSON::Serializable

    property message_text : String
    property parse_mode : String?
    property link_preview_options : LinkPreviewOptions?

    def initialize(
      @message_text : String,
      *,
      @parse_mode = nil,
      @link_preview_options = nil,
    )
    end
  end
end
