module TelegramBot
  class InlineQueryResultArticle < InlineQueryResult
    include JSON::Serializable

    property type : String = "article"
    property id : String
    property title : String
    property input_message_content : InputMessageContent
    property reply_markup : InlineKeyboardMarkup?
    property url : String?
    property description : String?
    property thumbnail_url : String?
    property thumbnail_width : Int32?
    property thumbnail_height : Int32?

    def initialize(
      @id : String,
      @title : String,
      @input_message_content : InputMessageContent,
      *,
      @reply_markup : InlineKeyboardMarkup? = nil,
      @url : String? = nil,
      @description = nil,
      @thumbnail_url = nil,
      @thumbnail_width = nil,
      @thumbnail_height = nil,
    )
    end
  end
end
