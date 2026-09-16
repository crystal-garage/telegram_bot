module TelegramBot
  class Bot
    # See: <https://core.telegram.org/bots/api#sendrichmessage>
    def send_rich_message(
      chat_id : Int | String,
      rich_message : InputRichMessage,
      business_connection_id : String? = nil,
      message_thread_id : Int? = nil,
      direct_messages_topic_id : Int? = nil,
      ephemeral_message_parameters : EphemeralMessageParameters? = nil,
      disable_notification : Bool? = nil,
      protect_content : Bool? = nil,
      allow_paid_broadcast : Bool? = nil,
      message_effect_id : String? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
      reply_parameters : ReplyParameters? = nil,
      reply_markup : ReplyMarkup = nil,
    ) : Message?
      res = def_request(
        "sendRichMessage",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        ephemeral_message_parameters,
        rich_message,
        disable_notification,
        protect_content,
        allow_paid_broadcast,
        message_effect_id,
        suggested_post_parameters,
        reply_parameters,
        reply_markup
      )

      Message.from_json(res.to_json) if res
    end

    # See: <https://core.telegram.org/bots/api#sendrichmessagedraft>
    def send_rich_message_draft(
      chat_id : Int,
      draft_id : Int,
      rich_message : InputRichMessage,
      message_thread_id : Int? = nil,
      can_stop : Bool? = nil,
      keep_on_stop : Bool? = nil,
    ) : Bool?
      res = def_force_request(
        "sendRichMessageDraft",
        chat_id,
        message_thread_id,
        draft_id,
        rich_message,
        can_stop,
        keep_on_stop
      )

      res.as_bool if res
    end
  end
end
