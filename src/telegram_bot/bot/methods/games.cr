module TelegramBot
  abstract class Bot
    def send_game(
      chat_id : Int | String,
      game_short_name : String,
      disable_notification : Bool? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Message?
      res = def_request(
        "sendGame",
        chat_id,
        game_short_name,
        disable_notification,
        reply_markup
      )

      Message.from_json(res.to_json) if res
    end

    def set_game_score(
      user_id : Int32,
      score : Int32,
      force : Bool? = nil,
      disable_edit_message : Bool? = nil,
      chat_id : Int | String? = nil,
      message_id : Int32? = nil,
      inline_message_id : String? = nil,
    ) : Message | Bool?
      res = def_request(
        "setGameScore",
        user_id,
        score,
        force,
        disable_edit_message,
        chat_id,
        message_id,
        inline_message_id
      )

      if res
        if res.as_bool?
          true
        else
          Message.from_json(res.to_json)
        end
      end
    end

    def get_game_high_scores(
      user_id : Int32,
      chat_id : Int | String? = nil,
      message_id : Int32? = nil,
      inline_message_id : String? = nil,
    ) : Array(GameHighScore)
      res = def_request(
        "getGameHighScores",
        user_id,
        chat_id,
        message_id,
        inline_message_id
      )

      res = res.not_nil!.as_a
      r = Array(GameHighScore).new
      res.each { |score| r << GameHighScore.from_json(score.to_json) }

      r
    end
  end
end
