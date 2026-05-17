module TelegramBot
  class Bot
    # Sends a game.
    #
    # See: <https://core.telegram.org/bots/api#sendgame>
    def send_game(
      chat_id : Int | String,
      game_short_name : String,
      disable_notification : Bool? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
      *,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      protect_content : Bool? = nil,
      allow_paid_broadcast : Bool? = nil,
      message_effect_id : String? = nil,
      reply_parameters : ReplyParameters? = nil,
    ) : Message?
      res = def_request(
        "sendGame",
        business_connection_id,
        chat_id,
        message_thread_id,
        game_short_name,
        disable_notification,
        protect_content,
        allow_paid_broadcast,
        message_effect_id,
        reply_parameters,
        reply_markup
      )

      Message.from_json(res.to_json) if res
    end

    # Sets a user's score in a game.
    #
    # See: <https://core.telegram.org/bots/api#setgamescore>
    def set_game_score(
      user_id : Int,
      score : Int,
      force : Bool? = nil,
      disable_edit_message : Bool? = nil,
      chat_id : Int? = nil,
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

    # Returns high scores for a game.
    #
    # See: <https://core.telegram.org/bots/api#getgamehighscores>
    def get_game_high_scores(
      user_id : Int,
      chat_id : Int? = nil,
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

      res.each_with_object([] of GameHighScore) { |s, scores| scores << GameHighScore.from_json(s.to_json) }
    end
  end
end
