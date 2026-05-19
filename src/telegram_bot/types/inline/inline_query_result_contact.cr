module TelegramBot
  class InlineQueryResultContact < InlineQueryResult
    include JSON::Serializable

    property type : String = "contact"
    property id : String
    property phone_number : String
    property first_name : String
    property last_name : String?
    property vcard : String?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?
    property thumbnail_url : String?
    property thumbnail_width : Int32?
    property thumbnail_height : Int32?

    def initialize(
      @id : String,
      @phone_number : String,
      @first_name : String,
      *,
      @last_name : String? = nil,
      @vcard : String? = nil,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @input_message_content : InputMessageContent? = nil,
      @thumbnail_url : String? = nil,
      @thumbnail_width : Int32? = nil,
      @thumbnail_height : Int32? = nil,
    )
    end
  end
end
