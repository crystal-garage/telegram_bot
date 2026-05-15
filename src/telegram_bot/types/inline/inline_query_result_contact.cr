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
  end

  def initialize(
    @id : String,
    @phone_number : String,
    @first_name : String,
    *,
    @last_name = nil,
    @vcard = nil,
    @reply_markup = nil,
    @input_message_content = nil,
    @thumbnail_url = nil,
    @thumbnail_width = nil,
    @thumbnail_height = nil,
  )
  end
end
