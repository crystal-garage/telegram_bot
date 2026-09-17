module TelegramBot
  class InlineQueryResultGame < InlineQueryResult
    include JSON::Serializable

    property type : String = "game"
    property id : String
    property game_short_name : String
    property reply_markup : InlineKeyboardMarkup?

    def initialize(
      @id : String,
      @game_short_name : String,
      *,
      @reply_markup : InlineKeyboardMarkup? = nil,
    )
    end
  end
end
