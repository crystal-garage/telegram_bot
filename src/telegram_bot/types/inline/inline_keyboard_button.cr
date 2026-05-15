module TelegramBot
  class InlineKeyboardButton
    include JSON::Serializable

    property text : String
    property icon_custom_emoji_id : String?
    property style : String?
    property url : String?
    property callback_data : String?
    property web_app : WebAppInfo?
    property login_url : LoginUrl?
    property switch_inline_query : String?
    property switch_inline_query_current_chat : String?
    property switch_inline_query_chosen_chat : SwitchInlineQueryChosenChat?
    property copy_text : CopyTextButton?
    property callback_game : CallbackGame?
    property? pay : Bool?

    def initialize(
      @text : String,
      *,
      @icon_custom_emoji_id : String? = nil,
      @style : String? = nil,
      @url : String? = nil,
      @callback_data : String? = nil,
      @web_app : WebAppInfo? = nil,
      @login_url : LoginUrl? = nil,
      @switch_inline_query : String? = nil,
      @switch_inline_query_current_chat : String? = nil,
      @switch_inline_query_chosen_chat : SwitchInlineQueryChosenChat? = nil,
      @copy_text : CopyTextButton? = nil,
      @callback_game : CallbackGame? = nil,
      @pay = nil,
    )
    end
  end
end
