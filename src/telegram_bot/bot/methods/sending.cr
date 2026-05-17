module TelegramBot
  class Bot
    # Sends text messages.
    #
    # See: <https://core.telegram.org/bots/api#sendmessage>
    def send_message(
      chat_id : Int | String,
      text : String,
      parse_mode : String? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      entities : Array(MessageEntity)? = nil,
      link_preview_options : LinkPreviewOptions? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      res = def_request(
        "sendMessage",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        text,
        parse_mode,
        entities,
        link_preview_options,
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

    # Replies to a message with text using `sendMessage`.
    def reply(message : Message, text : String) : Message?
      send_message(message.chat.id, text, reply_parameters: ReplyParameters.new(message.message_id))
    end

    # Sends checklists on behalf of a connected business account.
    #
    # See: <https://core.telegram.org/bots/api#sendchecklist>
    def send_checklist(
      business_connection_id : String,
      chat_id : Int | String,
      checklist : InputChecklist,
      disable_notification : Bool? = nil,
      protect_content : Bool? = nil,
      message_effect_id : String? = nil,
      reply_parameters : ReplyParameters? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Message?
      res = def_request(
        "sendChecklist",
        business_connection_id,
        chat_id,
        checklist,
        disable_notification,
        protect_content,
        message_effect_id,
        reply_parameters,
        reply_markup
      )

      Message.from_json(res.to_json) if res
    end

    # Forwards a message.
    #
    # See: <https://core.telegram.org/bots/api#forwardmessage>
    def forward_message(
      chat_id : Int | String,
      from_chat_id : Int | String,
      message_id : Int32,
      disable_notification : Bool? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      video_start_timestamp : Int32? = nil,
      protect_content : Bool? = nil,
      message_effect_id : String? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      res = def_request(
        "forwardMessage",
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        from_chat_id,
        video_start_timestamp,
        disable_notification,
        protect_content,
        message_effect_id,
        suggested_post_parameters,
        message_id
      )

      Message.from_json(res.to_json) if res
    end

    # Forwards multiple messages.
    #
    # See: <https://core.telegram.org/bots/api#forwardmessages>
    def forward_messages(
      chat_id : Int | String,
      from_chat_id : Int | String,
      message_ids : Array(Int32),
      disable_notification : Bool? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      protect_content : Bool? = nil,
    ) : Array(MessageId)
      res = def_request(
        "forwardMessages",
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        from_chat_id,
        message_ids,
        disable_notification,
        protect_content
      )

      res = res.not_nil!.as_a
      res.map { |message_id| MessageId.from_json(message_id.to_json) }
    end

    # Copies a message without a link to the original message.
    #
    # See: <https://core.telegram.org/bots/api#copymessage>
    def copy_message(
      chat_id : Int | String,
      from_chat_id : Int | String,
      message_id : Int32,
      caption : String? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      video_start_timestamp : Int32? = nil,
      show_caption_above_media : Bool? = nil,
      protect_content : Bool? = nil,
      allow_paid_broadcast : Bool? = nil,
      message_effect_id : String? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
      reply_parameters : ReplyParameters? = nil,
    ) : MessageId?
      res = def_request(
        "copyMessage",
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        from_chat_id,
        message_id,
        video_start_timestamp,
        caption,
        parse_mode,
        caption_entities,
        show_caption_above_media,
        disable_notification,
        protect_content,
        allow_paid_broadcast,
        message_effect_id,
        suggested_post_parameters,
        reply_parameters,
        reply_markup
      )

      MessageId.from_json(res.to_json) if res
    end

    # Copies multiple messages without links to the original messages.
    #
    # See: <https://core.telegram.org/bots/api#copymessages>
    def copy_messages(
      chat_id : Int | String,
      from_chat_id : Int | String,
      message_ids : Array(Int32),
      disable_notification : Bool? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      remove_caption : Bool? = nil,
      protect_content : Bool? = nil,
    ) : Array(MessageId)
      res = def_request(
        "copyMessages",
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        from_chat_id,
        message_ids,
        disable_notification,
        protect_content,
        remove_caption
      )

      res = res.not_nil!.as_a
      res.map { |message_id| MessageId.from_json(message_id.to_json) }
    end

    # Sends photos.
    #
    # See: <https://core.telegram.org/bots/api#sendphoto>
    def send_photo(
      chat_id : Int | String,
      photo : ::File | String,
      caption : String? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      show_caption_above_media : Bool? = nil,
      has_spoiler : Bool? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      res = def_request(
        "sendPhoto",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        photo,
        caption,
        parse_mode,
        caption_entities,
        show_caption_above_media,
        has_spoiler,
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

    # Sends audio files.
    #
    # See: <https://core.telegram.org/bots/api#sendaudio>
    def send_audio(
      chat_id : Int | String,
      audio : ::File | String,
      duration : Int32 | Time::Span? = nil,
      performer : String? = nil,
      title : String? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      thumbnail : ::File | String? = nil,
      caption : String? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      duration = duration.total_seconds.to_i if duration.is_a?(Time::Span)

      res = def_request(
        "sendAudio",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        audio,
        caption,
        parse_mode,
        caption_entities,
        duration,
        performer,
        title,
        thumbnail,
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

    # Sends general files.
    #
    # See: <https://core.telegram.org/bots/api#senddocument>
    def send_document(
      chat_id : Int | String,
      document : ::File | String,
      caption : String? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      thumbnail : ::File | String? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      disable_content_type_detection : Bool? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      res = def_request(
        "sendDocument",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        document,
        thumbnail,
        caption,
        parse_mode,
        caption_entities,
        disable_content_type_detection,
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

    # Sends stickers.
    #
    # See: <https://core.telegram.org/bots/api#sendsticker>
    def send_sticker(
      chat_id : Int | String,
      sticker : ::File | String,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      emoji : String? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      res = def_request(
        "sendSticker",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        sticker,
        emoji,
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

    # Sends video files.
    #
    # See: <https://core.telegram.org/bots/api#sendvideo>
    def send_video(
      chat_id : Int | String,
      video : ::File | String,
      duration : Int32 | Time::Span? = nil,
      width : Int32? = nil,
      height : Int32? = nil,
      caption : String? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      thumbnail : ::File | String? = nil,
      cover : ::File | String? = nil,
      start_timestamp : Int32? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      show_caption_above_media : Bool? = nil,
      has_spoiler : Bool? = nil,
      supports_streaming : Bool? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      duration = duration.total_seconds.to_i if duration.is_a?(Time::Span)

      res = def_request(
        "sendVideo",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        video,
        duration,
        width,
        height,
        thumbnail,
        cover,
        start_timestamp,
        caption,
        parse_mode,
        caption_entities,
        show_caption_above_media,
        has_spoiler,
        supports_streaming,
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

    # Sends animation files.
    #
    # See: <https://core.telegram.org/bots/api#sendanimation>
    def send_animation(
      chat_id : Int | String,
      animation : ::File | String,
      duration : Int32 | Time::Span? = nil,
      width : Int32? = nil,
      height : Int32? = nil,
      caption : String? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      thumbnail : ::File | String? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      show_caption_above_media : Bool? = nil,
      has_spoiler : Bool? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      duration = duration.total_seconds.to_i if duration.is_a?(Time::Span)

      res = def_request(
        "sendAnimation",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        animation,
        duration,
        width,
        height,
        thumbnail,
        caption,
        parse_mode,
        caption_entities,
        show_caption_above_media,
        has_spoiler,
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

    # Sends voice messages.
    #
    # See: <https://core.telegram.org/bots/api#sendvoice>
    def send_voice(
      chat_id : Int | String,
      voice : ::File | String,
      duration : Int32 | Time::Span? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      caption : String? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      duration = duration.total_seconds.to_i if duration.is_a?(Time::Span)

      res = def_request(
        "sendVoice",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        voice,
        caption,
        parse_mode,
        caption_entities,
        duration,
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

    # Sends video notes.
    #
    # See: <https://core.telegram.org/bots/api#sendvideonote>
    def send_video_note(
      chat_id : Int | String,
      video_note : ::File | String,
      duration : Int32 | Time::Span? = nil,
      length : Int32? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      thumbnail : ::File | String? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      duration = duration.total_seconds.to_i if duration.is_a?(Time::Span)

      res = def_request(
        "sendVideoNote",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        video_note,
        duration,
        length,
        thumbnail,
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

    # Sends paid media messages.
    #
    # See: <https://core.telegram.org/bots/api#sendpaidmedia>
    def send_paid_media(
      chat_id : Int | String,
      star_count : Int,
      media : Array(InputPaidMedia),
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      payload : String? = nil,
      caption : String? = nil,
      parse_mode : String? = nil,
      caption_entities : Array(MessageEntity)? = nil,
      show_caption_above_media : Bool? = nil,
      disable_notification : Bool? = nil,
      protect_content : Bool? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
      reply_parameters : ReplyParameters? = nil,
      reply_markup : ReplyMarkup = nil,
    ) : Message?
      res = def_request(
        "sendPaidMedia",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        star_count,
        media,
        payload,
        caption,
        parse_mode,
        caption_entities,
        show_caption_above_media,
        disable_notification,
        protect_content,
        allow_paid_broadcast,
        suggested_post_parameters,
        reply_parameters,
        reply_markup
      )

      Message.from_json(res.to_json) if res
    end

    # Sends a group of photos, videos, documents, or audios.
    #
    # See: <https://core.telegram.org/bots/api#sendmediagroup>
    def send_media_group(
      chat_id : Int | String,
      media : Array(InputMedia),
      disable_notification : Bool? = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Array(Message)
      res = def_request(
        "sendMediaGroup",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        media,
        disable_notification,
        protect_content,
        allow_paid_broadcast,
        message_effect_id,
        suggested_post_parameters,
        reply_parameters
      )

      res = res.not_nil!.as_a
      res.map { |message| Message.from_json(message.to_json) }
    end

    # Sends point locations.
    #
    # See: <https://core.telegram.org/bots/api#sendlocation>
    def send_location(
      chat_id : Int | String,
      latitude : Float,
      longitude : Float,
      live_period : Int32 | Time::Span? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      horizontal_accuracy : Float? = nil,
      heading : Int32? = nil,
      proximity_alert_radius : Int32? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      live_period = live_period.total_seconds.to_i if live_period.is_a?(Time::Span)

      res = def_request(
        "sendLocation",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        latitude,
        longitude,
        horizontal_accuracy,
        live_period,
        heading,
        proximity_alert_radius,
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

    # Edits live location messages.
    #
    # See: <https://core.telegram.org/bots/api#editmessagelivelocation>
    def edit_message_live_location(
      latitude : Float,
      longitude : Float,
      business_connection_id : String? = nil,
      chat_id : Int | String? = nil,
      message_id : Int32? = nil,
      inline_message_id : String? = nil,
      live_period : Int32 | Time::Span? = nil,
      horizontal_accuracy : Float? = nil,
      heading : Int32? = nil,
      proximity_alert_radius : Int32? = nil,
      reply_markup : ReplyMarkup? = nil,
    )
      live_period = live_period.total_seconds.to_i if live_period.is_a?(Time::Span)

      res = def_request(
        "editMessageLiveLocation",
        business_connection_id,
        chat_id,
        message_id,
        inline_message_id,
        latitude,
        longitude,
        live_period,
        horizontal_accuracy,
        heading,
        proximity_alert_radius,
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

    # Stops updating a live location message.
    #
    # See: <https://core.telegram.org/bots/api#stopmessagelivelocation>
    def stop_message_live_location(
      business_connection_id : String? = nil,
      chat_id : Int | String? = nil,
      message_id : Int32? = nil,
      inline_message_id : String? = nil,
      reply_markup : ReplyMarkup? = nil,
    )
      res = def_request(
        "stopMessageLiveLocation",
        business_connection_id,
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

    # Sends venue information.
    #
    # See: <https://core.telegram.org/bots/api#sendvenue>
    def send_venue(
      chat_id : Int | String,
      latitude : Float,
      longitude : Float,
      title : String,
      address : String,
      foursquare_id : String? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup? = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      foursquare_type : String? = nil,
      google_place_id : String? = nil,
      google_place_type : String? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      res = def_request(
        "sendVenue",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        latitude,
        longitude,
        title,
        address,
        foursquare_id,
        foursquare_type,
        google_place_id,
        google_place_type,
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

    # Sends phone contacts.
    #
    # See: <https://core.telegram.org/bots/api#sendcontact>
    def send_contact(
      chat_id : Int | String,
      phone_number : String,
      first_name : String,
      last_name : String? = nil,
      reply_markup : ReplyMarkup = nil,
      disable_notification : Bool? = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      vcard : String? = nil,
      protect_content : Bool? = nil,
      reply_parameters : ReplyParameters? = nil,
      message_effect_id : String? = nil,
      allow_paid_broadcast : Bool? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
    ) : Message?
      res = def_request(
        "sendContact",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        phone_number,
        first_name,
        last_name,
        vcard,
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

    # Sends native polls.
    #
    # See: <https://core.telegram.org/bots/api#sendpoll>
    def send_poll(
      chat_id : Int | String,
      question : String,
      options : Array(InputPollOption) | Array(String),
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      question_parse_mode : String? = nil,
      question_entities : Array(MessageEntity)? = nil,
      is_anonymous : Bool? = nil,
      type : String? = nil,
      allows_multiple_answers : Bool? = nil,
      allows_revoting : Bool? = nil,
      shuffle_options : Bool? = nil,
      allow_adding_options : Bool? = nil,
      hide_results_until_closes : Bool? = nil,
      members_only : Bool? = nil,
      country_codes : Array(String)? = nil,
      correct_option_ids : Array(Int32)? = nil,
      explanation : String? = nil,
      explanation_parse_mode : String? = nil,
      explanation_entities : Array(MessageEntity)? = nil,
      explanation_media : InputPollMedia? = nil,
      open_period : Int32 | Time::Span? = nil,
      close_date : Int32 | Time? = nil,
      is_closed : Bool? = nil,
      description : String? = nil,
      description_parse_mode : String? = nil,
      description_entities : Array(MessageEntity)? = nil,
      media : InputPollMedia? = nil,
      disable_notification : Bool? = nil,
      protect_content : Bool? = nil,
      allow_paid_broadcast : Bool? = nil,
      message_effect_id : String? = nil,
      reply_parameters : ReplyParameters? = nil,
      reply_markup : ReplyMarkup = nil,
    ) : Message?
      open_period = open_period.total_seconds.to_i if open_period.is_a?(Time::Span)
      close_date = close_date.to_unix if close_date.is_a?(Time)

      res = def_request(
        "sendPoll",
        business_connection_id,
        chat_id,
        message_thread_id,
        question,
        question_parse_mode,
        question_entities,
        options,
        is_anonymous,
        type,
        allows_multiple_answers,
        allows_revoting,
        shuffle_options,
        allow_adding_options,
        hide_results_until_closes,
        members_only,
        country_codes,
        correct_option_ids,
        explanation,
        explanation_parse_mode,
        explanation_entities,
        explanation_media,
        open_period,
        close_date,
        is_closed,
        description,
        description_parse_mode,
        description_entities,
        media,
        disable_notification,
        protect_content,
        allow_paid_broadcast,
        message_effect_id,
        reply_parameters,
        reply_markup
      )

      Message.from_json(res.to_json) if res
    end

    # Stops a poll sent by the bot.
    #
    # See: <https://core.telegram.org/bots/api#stoppoll>
    def stop_poll(
      chat_id : Int | String,
      message_id : Int32,
      business_connection_id : String? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Poll?
      res = def_request(
        "stopPoll",
        business_connection_id,
        chat_id,
        message_id,
        reply_markup
      )

      Poll.from_json(res.to_json) if res
    end

    # Sends an animated dice message.
    #
    # See: <https://core.telegram.org/bots/api#senddice>
    def send_dice(
      chat_id : Int | String,
      emoji : String? = nil,
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      disable_notification : Bool? = nil,
      protect_content : Bool? = nil,
      allow_paid_broadcast : Bool? = nil,
      message_effect_id : String? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
      reply_parameters : ReplyParameters? = nil,
      reply_markup : ReplyMarkup = nil,
    ) : Message?
      res = def_request(
        "sendDice",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        emoji,
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

    # Sends a message draft.
    #
    # See: <https://core.telegram.org/bots/api#sendmessagedraft>
    def send_message_draft(
      chat_id : Int,
      draft_id : Int,
      text : String? = nil,
      message_thread_id : Int32? = nil,
      parse_mode : String? = nil,
      entities : Array(MessageEntity)? = nil,
    ) : Bool?
      res = def_force_request(
        "sendMessageDraft",
        chat_id,
        message_thread_id,
        draft_id,
        text,
        parse_mode,
        entities
      )

      res.as_bool if res
    end
  end
end
