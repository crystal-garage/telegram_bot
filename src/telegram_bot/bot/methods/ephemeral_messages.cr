module TelegramBot
  class Bot
    # See: <https://core.telegram.org/bots/api#editephemeralmessagetext>
    def edit_ephemeral_message_text(
      chat_id : Int | String,
      receiver_user_id : Int,
      ephemeral_message_id : Int,
      text : String? = nil,
      parse_mode : String? = nil,
      entities : Array(MessageEntity)? = nil,
      rich_message : InputRichMessage? = nil,
      link_preview_options : LinkPreviewOptions? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Bool?
      res = def_request(
        "editEphemeralMessageText",
        chat_id,
        receiver_user_id,
        ephemeral_message_id,
        text,
        parse_mode,
        entities,
        rich_message,
        link_preview_options,
        reply_markup
      )

      res.as_bool if res
    end

    # See: <https://core.telegram.org/bots/api#editephemeralmessagemedia>
    def edit_ephemeral_message_media(
      chat_id : Int | String,
      receiver_user_id : Int,
      ephemeral_message_id : Int,
      media : InputMedia,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Bool?
      res = def_request(
        "editEphemeralMessageMedia",
        chat_id,
        receiver_user_id,
        ephemeral_message_id,
        media,
        reply_markup
      )

      res.as_bool if res
    end

    # See: <https://core.telegram.org/bots/api#editephemeralmessagecaption>
    def edit_ephemeral_message_caption(
      chat_id : Int | String,
      receiver_user_id : Int,
      ephemeral_message_id : Int,
      caption : String? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      show_caption_above_media : Bool? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Bool?
      res = def_request(
        "editEphemeralMessageCaption",
        chat_id,
        receiver_user_id,
        ephemeral_message_id,
        caption,
        parse_mode,
        caption_entities,
        show_caption_above_media,
        reply_markup
      )

      res.as_bool if res
    end

    # See: <https://core.telegram.org/bots/api#editephemeralmessagereplymarkup>
    def edit_ephemeral_message_reply_markup(
      chat_id : Int | String,
      receiver_user_id : Int,
      ephemeral_message_id : Int,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Bool?
      res = def_request(
        "editEphemeralMessageReplyMarkup",
        chat_id,
        receiver_user_id,
        ephemeral_message_id,
        reply_markup
      )

      res.as_bool if res
    end

    # See: <https://core.telegram.org/bots/api#deleteephemeralmessage>
    def delete_ephemeral_message(
      chat_id : Int | String,
      receiver_user_id : Int,
      ephemeral_message_id : Int,
    ) : Bool?
      res = def_request(
        "deleteEphemeralMessage",
        chat_id,
        receiver_user_id,
        ephemeral_message_id
      )

      res.as_bool if res
    end
  end
end
