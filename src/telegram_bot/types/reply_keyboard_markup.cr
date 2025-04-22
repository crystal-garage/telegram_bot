module TelegramBot
  class KeyboardButton
    include JSON::Serializable

    property text : String
    property? request_contact : Bool?
    property? request_location : Bool?

    def initialize(
      @text : String,
      *,
      @request_contact = nil,
      @request_location = nil,
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
