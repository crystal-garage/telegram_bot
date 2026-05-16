module TelegramBot
  class Bot
    # Sends an answer to a callback query.
    #
    # See: <https://core.telegram.org/bots/api#answercallbackquery>
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

    # Edits text and game messages.
    #
    # See: <https://core.telegram.org/bots/api#editmessagetext>
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

    # Edits captions of messages.
    #
    # See: <https://core.telegram.org/bots/api#editmessagecaption>
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

    # Edits animation, audio, document, live photo, photo, or video messages.
    #
    # See: <https://core.telegram.org/bots/api#editmessagemedia>
    def edit_message_media(
      media : InputMedia,
      chat_id : Int | String? = nil,
      message_id : Int32? = nil,
      inline_message_id : String? = nil,
      business_connection_id : String? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Message | Bool?
      res = def_request(
        "editMessageMedia",
        business_connection_id,
        chat_id,
        message_id,
        inline_message_id,
        media,
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

    # Edits checklists on behalf of a connected business account.
    #
    # See: <https://core.telegram.org/bots/api#editmessagechecklist>
    def edit_message_checklist(
      business_connection_id : String,
      chat_id : Int | String,
      message_id : Int32,
      checklist : InputChecklist,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Message?
      res = def_request(
        "editMessageChecklist",
        business_connection_id,
        chat_id,
        message_id,
        checklist,
        reply_markup
      )

      Message.from_json(res.to_json) if res
    end

    # Edits only the reply markup of messages.
    #
    # See: <https://core.telegram.org/bots/api#editmessagereplymarkup>
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

    # Deletes a message.
    #
    # See: <https://core.telegram.org/bots/api#deletemessage>
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

    # Deletes multiple messages.
    #
    # See: <https://core.telegram.org/bots/api#deletemessages>
    def delete_messages(
      chat_id : Int | String,
      message_ids : Array(Int32),
    ) : Bool?
      res = def_request(
        "deleteMessages",
        chat_id,
        message_ids
      )

      res.as_bool if res
    end

    # Approves a suggested post in a direct messages chat.
    #
    # See: <https://core.telegram.org/bots/api#approvesuggestedpost>
    def approve_suggested_post(
      chat_id : Int,
      message_id : Int32,
      send_date : Int32 | Time? = nil,
    ) : Bool?
      send_date = send_date.to_unix if send_date.is_a?(Time)

      res = def_request(
        "approveSuggestedPost",
        chat_id,
        message_id,
        send_date
      )

      res.as_bool if res
    end

    # Declines a suggested post in a direct messages chat.
    #
    # See: <https://core.telegram.org/bots/api#declinesuggestedpost>
    def decline_suggested_post(
      chat_id : Int,
      message_id : Int32,
      comment : String? = nil,
    ) : Bool?
      res = def_request(
        "declineSuggestedPost",
        chat_id,
        message_id,
        comment
      )

      res.as_bool if res
    end

    # Sends answers to an inline query.
    #
    # See: <https://core.telegram.org/bots/api#answerinlinequery>
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

    # Sends an answer to a Web App query.
    #
    # See: <https://core.telegram.org/bots/api#answerwebappquery>
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

    # Stores an inline message for later use.
    #
    # See: <https://core.telegram.org/bots/api#savepreparedinlinemessage>
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

    # Stores a keyboard button for later use.
    #
    # See: <https://core.telegram.org/bots/api#savepreparedkeyboardbutton>
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
