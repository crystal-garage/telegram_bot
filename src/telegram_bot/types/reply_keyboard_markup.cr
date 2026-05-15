module TelegramBot
  class KeyboardButton
    include JSON::Serializable

    property text : String
    property icon_custom_emoji_id : String?
    property style : String?
    property request_users : KeyboardButtonRequestUsers?
    property request_chat : KeyboardButtonRequestChat?
    property request_managed_bot : KeyboardButtonRequestManagedBot?
    property? request_contact : Bool?
    property? request_location : Bool?
    property request_poll : KeyboardButtonPollType?
    property web_app : WebAppInfo?

    def initialize(
      @text : String,
      *,
      @icon_custom_emoji_id : String? = nil,
      @style : String? = nil,
      @request_users : KeyboardButtonRequestUsers? = nil,
      @request_chat : KeyboardButtonRequestChat? = nil,
      @request_managed_bot : KeyboardButtonRequestManagedBot? = nil,
      @request_contact = nil,
      @request_location = nil,
      @request_poll : KeyboardButtonPollType? = nil,
      @web_app : WebAppInfo? = nil,
    )
    end
  end

  class ReplyKeyboardMarkup
    include JSON::Serializable

    property keyboard : Array(Array(KeyboardButton))
    property? resize_keyboard : Bool?
    property? one_time_keyboard : Bool?
    property? selective : Bool?

    def initialize(
      @keyboard : Array(Array(KeyboardButton)),
      *,
      @resize_keyboard = nil,
      @one_time_keyboard = nil,
      @selective = nil,
    )
    end

    # Alternative constructor that allows to build markup object with text-only buttons
    def initialize(
      keyboard : Array(Array(String)),
      *,
      resize_keyboard : Bool? = nil,
      one_time_keyboard : Bool? = nil,
      selective : Bool? = nil,
    )
      buttons = keyboard.map { |row| row.map { |text| KeyboardButton.new(text) } }
      initialize(
        buttons,
        resize_keyboard: resize_keyboard,
        one_time_keyboard: one_time_keyboard,
        selective: selective
      )
    end
  end
end
