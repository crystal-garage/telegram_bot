require "./input_message_content.cr"

module TelegramBot
  class InputContactMessageContent < InputMessageContent
    include JSON::Serializable

    property phone_number : String
    property first_name : String
    property last_name : String?
    property vcard : String?

    def initialize(
      @phone_number : String,
      @first_name : String,
      @last_name = nil,
      @vcard = nil,
    )
    end
  end
end
