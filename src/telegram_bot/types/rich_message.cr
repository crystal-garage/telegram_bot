module TelegramBot
  class RichMessage
    include JSON::Serializable

    property blocks : Array(RichBlock)
    property? is_rtl : Bool?

    def initialize(
      @blocks : Array(RichBlock),
      *,
      @is_rtl : Bool? = nil,
    )
    end
  end

  class RichMessageButton
    include JSON::Serializable

    property text : RichText
    property style : String?
    property url : String?
    property callback_data : String?
    property web_app : WebAppInfo?
    property login_url : LoginUrl?
    property switch_inline_query : String?
    property switch_inline_query_current_chat : String?
    property switch_inline_query_chosen_chat : SwitchInlineQueryChosenChat?
    property copy_text : CopyTextButton?
    property disabled : DisabledButton?

    def initialize(
      @text : RichText,
      *,
      @style : String? = nil,
      @url : String? = nil,
      @callback_data : String? = nil,
      @web_app : WebAppInfo? = nil,
      @login_url : LoginUrl? = nil,
      @switch_inline_query : String? = nil,
      @switch_inline_query_current_chat : String? = nil,
      @switch_inline_query_chosen_chat : SwitchInlineQueryChosenChat? = nil,
      @copy_text : CopyTextButton? = nil,
      @disabled : DisabledButton? = nil,
    )
    end
  end

  class InputRichMessage
    include JSON::Serializable

    property blocks : Array(InputRichBlock)?
    property html : String?
    property markdown : String?
    property media : Array(InputRichMessageMedia)?
    property? is_rtl : Bool?
    property? skip_entity_detection : Bool?

    def initialize(
      *,
      @blocks : Array(InputRichBlock)? = nil,
      @html : String? = nil,
      @markdown : String? = nil,
      @media : Array(InputRichMessageMedia)? = nil,
      @is_rtl : Bool? = nil,
      @skip_entity_detection : Bool? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@blocks, attachments)
      TelegramBot.collect_attachment(@media, attachments)
    end
  end

  class InputRichMessageMedia
    include JSON::Serializable

    property id : String
    property media : InputMediaAnimation | InputMediaAudio | InputMediaDocument | InputMediaPhoto | InputMediaVideo | InputMediaVoiceNote

    def initialize(
      @id : String,
      @media : InputMediaAnimation | InputMediaAudio | InputMediaDocument | InputMediaPhoto | InputMediaVideo | InputMediaVoiceNote,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@media, attachments)
    end
  end
end
