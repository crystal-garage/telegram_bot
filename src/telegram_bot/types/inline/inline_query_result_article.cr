module TelegramBot
  class InlineQueryResultArticle < InlineQueryResult
    include JSON::Serializable

    property type : String = "article"
    property id : String
    property title : String
    property input_message_content : InputMessageContent
    property reply_markup : InlineKeyboardMarkup?
    property url : String?
    property? hide_url : Bool?
    property description : String?
    property thumb_url : String?
    property thumb_width : Int32?
    property thumb_height : Int32?

    def initialize(
      @id : String,
      @title : String,
      @input_message_content : InputMessageContent,
      *,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @url : String? = nil,
      @hide_url = nil,
      @description = nil,
      @thumb_url = nil,
      @thumb_width = nil,
      @thumb_height = nil,
    )
    end
  end
end
