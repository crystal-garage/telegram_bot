module TelegramBot
  class InputRichMessageContent < InputMessageContent
    include JSON::Serializable

    property rich_message : InputRichMessage

    def initialize(
      @rich_message : InputRichMessage,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@rich_message, attachments)
    end
  end
end
