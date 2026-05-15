module TelegramBot
  abstract class Bot
    def answer_callback_query(
      callback_query_id : String,
      text : String? = nil,
      show_alert : Bool? = nil,
      url : String? = nil,
      cache_time : Int32? = nil,
    )
      res = def_request(
        "answerCallbackQuery",
        callback_query_id,
        text,
        show_alert,
        url,
        cache_time
      )

      res.as_bool if res
    end

    def edit_message_text(
      chat_id : Int | String? = nil,
      message_id : Int32? = nil,
      inline_message_id : String? = nil,
      text : String? = nil,
      parse_mode : String? = nil,
      link_preview_options : LinkPreviewOptions? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Message | Bool?
      res = def_request(
        "editMessageText",
        chat_id,
        message_id,
        inline_message_id,
        text,
        parse_mode,
        link_preview_options,
        reply_markup
      )

      if res
        if res.as_bool?
          true
        else
          Message.from_json(res.to_json)
        end
      end
    end

    def edit_message_caption(
      chat_id : Int | String? = nil,
      message_id : Int32? = nil,
      inline_message_id : String? = nil,
      caption : String? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Message | Bool?
      res = def_request(
        "editMessageCaption",
        chat_id,
        message_id,
        inline_message_id,
        caption,
        reply_markup
      )

      if res
        if res.as_bool?
          true
        else
          Message.from_json(res.to_json)
        end
      end
    end

    def edit_message_reply_markup(
      chat_id : Int | String? = nil,
      message_id : Int32? = nil,
      inline_message_id : String? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Message | Bool?
      res = def_request(
        "editMessageReplyMarkup",
        chat_id,
        message_id,
        inline_message_id,
        reply_markup
      )

      if res
        if res.as_bool?
          true
        else
          Message.from_json(res.to_json)
        end
      end
    end

    def delete_message(
      chat_id : Int | String,
      message_id : Int32,
    ) : Message | Bool?
      res = def_request(
        "deleteMessage",
        chat_id,
        message_id
      )

      if res
        if res.as_bool?
          true
        else
          Message.from_json(res.to_json)
        end
      end
    end

    def answer_inline_query(
      inline_query_id : String,
      results : Array(InlineQueryResult),
      cache_time : Int32? = nil,
      is_personal : Bool? = nil,
      next_offset : String? = nil,
      switch_pm_text : String? = nil,
      switch_pm_parameter : String? = nil,
    ) : Bool?
      res = def_request(
        "answerInlineQuery",
        inline_query_id,
        cache_time,
        is_personal,
        next_offset,
        results,
        switch_pm_text,
        switch_pm_parameter
      )

      res.as_bool if res
    end

    def answer_web_app_query(
      web_app_query_id : String,
      result : InlineQueryResult,
    ) : SentWebAppMessage
      res = def_request(
        "answerWebAppQuery",
        web_app_query_id,
        result
      )

      SentWebAppMessage.from_json(res.to_json)
    end

    def save_prepared_inline_message(
      user_id : Int,
      result : InlineQueryResult,
      allow_user_chats : Bool? = nil,
      allow_bot_chats : Bool? = nil,
      allow_group_chats : Bool? = nil,
      allow_channel_chats : Bool? = nil,
    ) : PreparedInlineMessage
      res = def_request(
        "savePreparedInlineMessage",
        user_id,
        result,
        allow_user_chats,
        allow_bot_chats,
        allow_group_chats,
        allow_channel_chats
      )

      PreparedInlineMessage.from_json(res.to_json)
    end

    def save_prepared_keyboard_button(
      user_id : Int,
      button : KeyboardButton,
    ) : PreparedKeyboardButton
      res = def_request(
        "savePreparedKeyboardButton",
        user_id,
        button
      )

      PreparedKeyboardButton.from_json(res.to_json)
    end
  end
end
