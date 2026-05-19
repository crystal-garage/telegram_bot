module TelegramBot
  class InputTextMessageContent < InputMessageContent
    include JSON::Serializable

    property message_text : String
    property parse_mode : String?
    property entities : Array(MessageEntity)?
    property link_preview_options : LinkPreviewOptions?

    def initialize(
      @message_text : String,
      *,
      @parse_mode : String? = nil,
      @entities : Array(MessageEntity)? = nil,
      @link_preview_options : LinkPreviewOptions? = nil,
    )
    end
  end
end
