module TelegramBot
  class InlineQueryResultCachedVideo < InlineQueryResult
    include JSON::Serializable

    property type : String = "video"
    property id : String
    property video_file_id : String
    property title : String
    property caption : String?
    property description : String?
    property reply_markup : InlineKeyboardMarkup?
    property input_message_content : InputMessageContent?
  end

  def initialize(
    @id : String,
    @video_file_id : String,
    @title : String,
    *,
    @caption = nil,
    @description = nil,
    @reply_markup = nil,
    @input_message_content = nil,
  )
  end
end
