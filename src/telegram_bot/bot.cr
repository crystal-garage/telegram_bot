require "http/client"
require "http/server"
require "json"
require "log"
require "./fiber.cr"
require "./types/inline/*"
require "./types/*"

require "./http_client_multipart.cr"
require "./http_client.cr"
require "./response_client.cr"
require "./api_exception.cr"

module TelegramBot
  abstract class Bot
    Log = ::Log.for(self)

    # handle messages
    def handle(message : Message)
      raise "message handler is not implemented"
    end

    # handle edited messages
    def handle_edited(message : Message)
      raise "edited message handler is not implemented"
    end

    def handle_channel_post(message : Message)
      raise "channel post handler is not implemented"
    end

    def handle_edited_channel_post(message : Message)
      raise "edited channel post handler is not implemented"
    end

    # handle inline query
    def handle(inline_query : InlineQuery)
      raise "inline_query handler is not implemented"
    end

    # handle chosen inlien query
    def handle(chosen_inline_result : ChosenInlineResult)
      raise "chosen_inline_result handler is not implemented"
    end

    # handle callback query
    def handle(callback_query : CallbackQuery)
      raise "callback_query handler is not implemented"
    end

    # handle business connection updates
    def handle_business_connection(business_connection : BusinessConnection)
      raise "business_connection handler is not implemented"
    end

    # handle business messages
    def handle_business_message(message : Message)
      raise "business_message handler is not implemented"
    end

    # handle edited business messages
    def handle_edited_business_message(message : Message)
      raise "edited_business_message handler is not implemented"
    end

    # handle deleted business messages
    def handle_deleted_business_messages(deleted_business_messages : BusinessMessagesDeleted)
      raise "deleted_business_messages handler is not implemented"
    end

    # handle guest messages
    def handle_guest_message(message : Message)
      raise "guest_message handler is not implemented"
    end

    # handle message reaction updates
    def handle(message_reaction : MessageReactionUpdated)
      raise "message_reaction handler is not implemented"
    end

    # handle message reaction count updates
    def handle(message_reaction_count : MessageReactionCountUpdated)
      raise "message_reaction_count handler is not implemented"
    end

    # handle shipping query
    def handle(shipping_query : ShippingQuery)
      raise "shipping_query handler is not implemented"
    end

    # handle pre-checkout query
    def handle(pre_checkout_query : PreCheckoutQuery)
      raise "pre_checkout_query handler is not implemented"
    end

    # handle purchased paid media updates
    def handle(purchased_paid_media : PaidMediaPurchased)
      raise "purchased_paid_media handler is not implemented"
    end

    # handle poll updates
    def handle(poll : Poll)
      raise "poll handler is not implemented"
    end

    # handle poll answer updates
    def handle(poll_answer : PollAnswer)
      raise "poll_answer handler is not implemented"
    end

    # handle bot chat member status updates
    def handle_my_chat_member(my_chat_member : ChatMemberUpdated)
      raise "my_chat_member handler is not implemented"
    end

    # handle chat member status updates
    def handle(chat_member : ChatMemberUpdated)
      raise "chat_member handler is not implemented"
    end

    # handle chat join requests
    def handle(chat_join_request : ChatJoinRequest)
      raise "chat_join_request handler is not implemented"
    end

    # handle chat boost updates
    def handle(chat_boost : ChatBoostUpdated)
      raise "chat_boost handler is not implemented"
    end

    # handle removed chat boost updates
    def handle(removed_chat_boost : ChatBoostRemoved)
      raise "removed_chat_boost handler is not implemented"
    end

    # handle managed bot updates
    def handle(managed_bot : ManagedBotUpdated)
      raise "managed_bot handler is not implemented"
    end

    # @name username of the bot
    # @token
    # @allowlist
    # @blocklist
    # @updates_timeout
    def initialize(@name : String,
                   @token : String,
                   @allowlist : Array(String)? = nil,
                   @blocklist : Array(String)? = nil,
                   @updates_timeout : Int32? = nil,
                   @allowed_updates : Array(String)? = nil)
      @nextoffset = 0
      @running = false
    end

    # run long polling in a loop and call handlers for messages
    def polling
      Log.info { "#{self.class} is ready to lead" }
      setup_trap_signal
      @running = true
      while @running
        begin
          updates = get_updates
          updates.each do |u|
            spawn handle_update(u)
          end
        rescue ex
          Log.error { ex }
        end
      end
    end

    def stop
      Log.info { "#{self.class} is going to take a rest" }
      @running = false
    end

    private def setup_trap_signal
      Process.on_terminate do
        stop
        exit
      end
    end

    def serve(bind_address : String = "127.0.0.1", bind_port : Int32 = 80, ssl_certificate_path : String? = nil, ssl_key_path : String? = nil)
      server = HTTP::Server.new do |context|
        begin
          Fiber.current.telegram_bot_server_http_context = context
          handle_update(TelegramBot::Update.from_json(context.request.body.not_nil!))
        rescue ex
          Log.error { ex }
        ensure
          Fiber.current.telegram_bot_server_http_context = nil
        end
      end

      if ssl_certificate_path && ssl_key_path
        context = OpenSSL::SSL::Context::Server.new
        context.certificate_chain = ssl_certificate_path
        context.private_key = ssl_key_path
        server.bind_tls(bind_address, bind_port, context)
        Log.info { "Listening for Telegram requests in #{bind_address}:#{bind_port} with tls" }
      else
        server.bind_tcp(bind_address, bind_port)
        Log.info { "Listening for Telegram requests in #{bind_address}:#{bind_port}" }
      end

      server.listen
    end

    def handle_update(u)
      if msg = u.message
        return if !allowed_user?(msg)
        handle msg
      elsif query = u.inline_query
        return if !allowed_user?(query)
        handle query
      elsif chosen = u.chosen_inline_result
        return if !allowed_user?(chosen)
        handle chosen
      elsif callback_query = u.callback_query
        return if !allowed_user?(callback_query)
        handle callback_query
      elsif business_connection = u.business_connection
        handle_business_connection business_connection
      elsif message = u.business_message
        return if !allowed_user?(message)
        handle_business_message message
      elsif message = u.edited_business_message
        return if !allowed_user?(message)
        handle_edited_business_message message
      elsif deleted_business_messages = u.deleted_business_messages
        handle_deleted_business_messages deleted_business_messages
      elsif message = u.guest_message
        return if !allowed_user?(message)
        handle_guest_message message
      elsif message_reaction = u.message_reaction
        handle message_reaction
      elsif message_reaction_count = u.message_reaction_count
        handle message_reaction_count
      elsif shipping_query = u.shipping_query
        return if !allowed_user?(shipping_query)
        handle shipping_query
      elsif pre_checkout_query = u.pre_checkout_query
        return if !allowed_user?(pre_checkout_query)
        handle pre_checkout_query
      elsif purchased_paid_media = u.purchased_paid_media
        handle purchased_paid_media
      elsif poll = u.poll
        handle poll
      elsif poll_answer = u.poll_answer
        handle poll_answer
      elsif my_chat_member = u.my_chat_member
        handle_my_chat_member my_chat_member
      elsif chat_member = u.chat_member
        handle chat_member
      elsif chat_join_request = u.chat_join_request
        handle chat_join_request
      elsif chat_boost = u.chat_boost
        handle chat_boost
      elsif removed_chat_boost = u.removed_chat_boost
        handle removed_chat_boost
      elsif managed_bot = u.managed_bot
        handle managed_bot
      elsif message = u.edited_message
        return if !allowed_user?(message)
        handle_edited message
      elsif post = u.channel_post
        return if !allowed_user?(post)
        handle_channel_post post
      elsif post = u.edited_channel_post
        return if !allowed_user?(post)
        handle_edited_channel_post post
      end
    rescue ex
      Log.error { "update was not handled because: #{ex.message}" }
    end

    private def allowed_user?(msg) : Bool
      if msg.is_a?(Message)
        if mf = msg.from
          from = mf
        else
          return @allowlist.nil?
        end
      else
        from = msg.from
      end

      if blocklist = @blocklist
        if username = from.username
          if blocklist.includes?(username)
            # on the blocklist
            Log.info { "#{username} blocked because he/she is on the blocklist" }
            return false
          else
            # not on the blocklist
            return true
          end
        else
          # doesn't have username at all
        end
      end

      if allowlist = @allowlist
        if username = from.username
          if allowlist.includes?(username)
            # on the allowlist
            return true
          else
            # not on the allowlist
            Log.info { "#{username} blocked because he/she is not on the allowlist" }
            return false
          end
        else
          # doesn't have username at all
          Log.info { "user without username is blocked because allowlist is set" }
          return false
        end
      end
      true
    end

    protected def request(method : String, force_http : Bool = false, params : Hash = {} of String => String | Int32?)
      client = if !force_http && (context = Fiber.current.telegram_bot_server_http_context)
                 ResponseClient.new(context.not_nil!.response) ensure Fiber.current.telegram_bot_server_http_context = nil
               else
                 HttpClient.new(@token)
               end

      serialized_params = serialize_params(params)

      response = if serialized_params.values.any?(::File)
                   multipart_params = HTTP::Client::MultipartBody.new(serialized_params)
                   client.post_multipart method, multipart_params
                 elsif !serialized_params.empty?
                   form_params = serialized_params.reduce(Hash(String, String).new) { |h, (k, v)| h[k] = v.to_s; h }
                   client.post_form method, form_params
                 else
                   client.post method
                 end
      client.close

      return if response.nil?
      handle_http_response(response)
    end

    protected def serialize_params(params : Hash) : Hash(String, String | ::File)
      params.reduce(Hash(String, String | ::File).new) do |serialized, (key, value)|
        unless value.nil?
          serialized[key] = serialize_param(value)
        end

        serialized
      end
    end

    protected def serialize_param(value : ::File) : ::File
      value
    end

    protected def serialize_param(value : String) : String
      value
    end

    protected def serialize_param(value : Bool) : String
      value.to_s
    end

    protected def serialize_param(value : Number) : String
      value.to_s
    end

    protected def serialize_param(value : Array) : String
      value.to_json
    end

    protected def serialize_param(value) : String
      value.to_json
    end

    protected def handle_http_response(response)
      if response.status_code == 200
        json = JSON.parse(response.body)
        if json["ok"]
          json["result"]
        else
          raise APIException.new(200, json)
        end
      else
        json = begin
          JSON.parse(response.body)
        rescue JSON::ParseException
          nil
        end

        raise APIException.new(response.status_code, json)
      end
    end

    def get_me
      request "getMe", force_http: true
    end

    private def get_updates(offset = @nextoffset, limit : Int32? = nil, timeout : Int32? = @updates_timeout, allowed_updates : Array(String)? = @allowed_updates)
      data = request("getUpdates", force_http: true, params: {"offset" => offset, "limit" => limit, "timeout" => timeout, "allowed_updates" => allowed_updates}).not_nil!

      r = [] of Update
      data.as_a.each do |json|
        r << Update.from_json(json.to_json)
      end

      if !r.empty?
        @nextoffset = r.last.update_id + 1
      end
      r
    end

    macro def_request(name, *args)
      params = {
        {% for arg in args %}
          {{ arg.stringify }} => {{ arg.id }},
        {% end %}
      }

      request {{ name }}, force_http: false, params: params
    end

    macro def_force_request(name, *args)
      params = {
        {% for arg in args %}
          {{ arg.stringify }} => {{ arg.id }},
        {% end %}
      }

      request {{ name }}, force_http: true, params: params
    end

    alias ReplyMarkup = InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply?

    def send_message(chat_id : Int | String,
                     text : String,
                     parse_mode : String? = nil,
                     disable_web_page_preview : Bool? = nil,
                     disable_notification : Bool? = nil,
                     reply_to_message_id : Int32? = nil,
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
                     suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendMessage", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, text, parse_mode, entities, link_preview_options, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, disable_web_page_preview, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def reply(message : Message, text : String) : Message?
      send_message(message.chat.id, text, reply_to_message_id: message.message_id)
    end

    def forward_message(chat_id : Int | String,
                        from_chat_id : Int | String,
                        message_id : Int32,
                        disable_notification : Bool? = nil,
                        message_thread_id : Int32? = nil,
                        direct_messages_topic_id : Int64? = nil,
                        video_start_timestamp : Int32? = nil,
                        protect_content : Bool? = nil,
                        message_effect_id : String? = nil,
                        suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "forwardMessage", chat_id, message_thread_id, direct_messages_topic_id, from_chat_id, video_start_timestamp, disable_notification, protect_content, message_effect_id, suggested_post_parameters, message_id
      Message.from_json res.to_json if res
    end

    def forward_messages(chat_id : Int | String,
                         from_chat_id : Int | String,
                         message_ids : Array(Int32),
                         disable_notification : Bool? = nil,
                         message_thread_id : Int32? = nil,
                         direct_messages_topic_id : Int64? = nil,
                         protect_content : Bool? = nil) : Array(MessageId)
      res = def_request "forwardMessages", chat_id, message_thread_id, direct_messages_topic_id, from_chat_id, message_ids, disable_notification, protect_content
      res = res.not_nil!.as_a
      res.map { |message_id| MessageId.from_json(message_id.to_json) }
    end

    def copy_message(chat_id : Int | String,
                     from_chat_id : Int | String,
                     message_id : Int32,
                     caption : String? = nil,
                     parse_mode : String? = nil,
                     caption_entities : Array(MessageEntity)? = nil,
                     disable_notification : Bool? = nil,
                     reply_to_message_id : Int32? = nil,
                     reply_markup : ReplyMarkup = nil,
                     message_thread_id : Int32? = nil,
                     direct_messages_topic_id : Int64? = nil,
                     video_start_timestamp : Int32? = nil,
                     show_caption_above_media : Bool? = nil,
                     protect_content : Bool? = nil,
                     allow_paid_broadcast : Bool? = nil,
                     message_effect_id : String? = nil,
                     suggested_post_parameters : SuggestedPostParameters? = nil,
                     reply_parameters : ReplyParameters? = nil) : MessageId?
      res = def_request "copyMessage", chat_id, message_thread_id, direct_messages_topic_id, from_chat_id, message_id, video_start_timestamp, caption, parse_mode, caption_entities, show_caption_above_media, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      MessageId.from_json res.to_json if res
    end

    def copy_messages(chat_id : Int | String,
                      from_chat_id : Int | String,
                      message_ids : Array(Int32),
                      disable_notification : Bool? = nil,
                      message_thread_id : Int32? = nil,
                      direct_messages_topic_id : Int64? = nil,
                      remove_caption : Bool? = nil,
                      protect_content : Bool? = nil) : Array(MessageId)
      res = def_request "copyMessages", chat_id, message_thread_id, direct_messages_topic_id, from_chat_id, message_ids, disable_notification, protect_content, remove_caption
      res = res.not_nil!.as_a
      res.map { |message_id| MessageId.from_json(message_id.to_json) }
    end

    # @photo file or file id
    def send_photo(chat_id : Int | String,
                   photo : ::File | String,
                   caption : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
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
                   suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendPhoto", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, photo, caption, parse_mode, caption_entities, show_caption_above_media, has_spoiler, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_audio(chat_id : Int | String,
                   audio : ::File | String,
                   duration : Int32? = nil,
                   performer : String? = nil,
                   title : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
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
                   suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendAudio", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, audio, caption, parse_mode, caption_entities, duration, performer, title, thumbnail, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_document(chat_id : Int | String,
                      document : ::File | String,
                      caption : String? = nil,
                      disable_notification : Bool? = nil,
                      reply_to_message_id : Int32? = nil,
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
                      suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendDocument", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, document, thumbnail, caption, parse_mode, caption_entities, disable_content_type_detection, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_sticker(chat_id : Int | String,
                     sticker : ::File | String,
                     disable_notification : Bool? = nil,
                     reply_to_message_id : Int32? = nil,
                     reply_markup : ReplyMarkup = nil,
                     business_connection_id : String? = nil,
                     message_thread_id : Int32? = nil,
                     direct_messages_topic_id : Int64? = nil,
                     emoji : String? = nil,
                     protect_content : Bool? = nil,
                     reply_parameters : ReplyParameters? = nil,
                     message_effect_id : String? = nil,
                     allow_paid_broadcast : Bool? = nil,
                     suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendSticker", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, sticker, emoji, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_video(chat_id : Int | String,
                   video : ::File | String,
                   duration : Int32? = nil,
                   width : Int32? = nil,
                   height : Int32? = nil,
                   caption : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
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
                   suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendVideo", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, video, duration, width, height, thumbnail, cover, start_timestamp, caption, parse_mode, caption_entities, show_caption_above_media, has_spoiler, supports_streaming, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_animation(chat_id : Int | String,
                       animation : ::File | String,
                       duration : Int32? = nil,
                       width : Int32? = nil,
                       height : Int32? = nil,
                       caption : String? = nil,
                       disable_notification : Bool? = nil,
                       reply_to_message_id : Int32? = nil,
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
                       suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendAnimation", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, animation, duration, width, height, thumbnail, caption, parse_mode, caption_entities, show_caption_above_media, has_spoiler, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_voice(chat_id : Int | String,
                   voice : ::File | String,
                   duration : Int32? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
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
                   suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendVoice", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, voice, caption, parse_mode, caption_entities, duration, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_video_note(chat_id : Int | String,
                        video_note : ::File | String,
                        duration : Int32? = nil,
                        length : Int32? = nil,
                        disable_notification : Bool? = nil,
                        reply_to_message_id : Int32? = nil,
                        reply_markup : ReplyMarkup = nil,
                        business_connection_id : String? = nil,
                        message_thread_id : Int32? = nil,
                        direct_messages_topic_id : Int64? = nil,
                        thumbnail : ::File | String? = nil,
                        protect_content : Bool? = nil,
                        reply_parameters : ReplyParameters? = nil,
                        message_effect_id : String? = nil,
                        allow_paid_broadcast : Bool? = nil,
                        suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendVideoNote", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, video_note, duration, length, thumbnail, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_paid_media(chat_id : Int | String,
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
                        reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendPaidMedia", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, star_count, media, payload, caption, parse_mode, caption_entities, show_caption_above_media, disable_notification, protect_content, allow_paid_broadcast, suggested_post_parameters, reply_parameters, reply_markup
      Message.from_json res.to_json if res
    end

    def send_media_group(chat_id : Int | String,
                         media : Array(InputMedia),
                         disable_notification : Bool? = nil,
                         reply_to_message_id : Int32? = nil,
                         business_connection_id : String? = nil,
                         message_thread_id : Int32? = nil,
                         direct_messages_topic_id : Int64? = nil,
                         protect_content : Bool? = nil,
                         reply_parameters : ReplyParameters? = nil,
                         message_effect_id : String? = nil,
                         allow_paid_broadcast : Bool? = nil,
                         suggested_post_parameters : SuggestedPostParameters? = nil) : Array(Message)
      res = def_request "sendMediaGroup", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, media, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id
      res = res.not_nil!.as_a
      res.map { |message| Message.from_json(message.to_json) }
    end

    def send_location(chat_id : Int | String,
                      latitude : Float,
                      longitude : Float,
                      live_period : Int32? = nil,
                      disable_notification : Bool? = nil,
                      reply_to_message_id : Int32? = nil,
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
                      suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendLocation", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, latitude, longitude, horizontal_accuracy, live_period, heading, proximity_alert_radius, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def edit_message_live_location(latitude : Float,
                                   longitude : Float,
                                   chat_id : Int | String? = nil,
                                   message_id : Int32? = nil,
                                   inline_message_id : String? = nil,
                                   reply_markup : ReplyMarkup? = nil)
      res = def_request "editMessageLiveLocation", chat_id, message_id, inline_message_id, latitude, longitude, reply_markup
      if res
        if res.as_bool?
          true
        else
          Message.from_json res.to_json
        end
      end
    end

    def stop_message_live_location(chat_id : Int | String? = nil,
                                   message_id : Int32? = nil,
                                   inline_message_id : String? = nil,
                                   reply_markup : ReplyMarkup? = nil)
      res = def_request "stopMessageLiveLocation", chat_id, message_id, inline_message_id, reply_markup
      if res
        if res.as_bool?
          true
        else
          Message.from_json res.to_json
        end
      end
    end

    def send_venue(chat_id : Int | String,
                   latitude : Float,
                   longitude : Float,
                   title : String,
                   address : String,
                   forsquare_id : String? = nil,
                   disable_notification : Bool? = nil,
                   reply_to_message_id : Int32? = nil,
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
                   suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendVenue", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, latitude, longitude, title, address, forsquare_id, foursquare_type, google_place_id, google_place_type, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_contact(chat_id : Int | String,
                     phone_number : String,
                     first_name : String,
                     last_name : String? = nil,
                     reply_to_message_id : Int32? = nil,
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
                     suggested_post_parameters : SuggestedPostParameters? = nil) : Message?
      res = def_request "sendContact", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, phone_number, first_name, last_name, vcard, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def send_poll(chat_id : Int | String,
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
                  open_period : Int32? = nil,
                  close_date : Int32? = nil,
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
                  reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendPoll", business_connection_id, chat_id, message_thread_id, question, question_parse_mode, question_entities, options, is_anonymous, type, allows_multiple_answers, allows_revoting, shuffle_options, allow_adding_options, hide_results_until_closes, members_only, country_codes, correct_option_ids, explanation, explanation_parse_mode, explanation_entities, explanation_media, open_period, close_date, is_closed, description, description_parse_mode, description_entities, media, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, reply_parameters, reply_markup
      Message.from_json res.to_json if res
    end

    def send_dice(chat_id : Int | String,
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
                  reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendDice", business_connection_id, chat_id, message_thread_id, direct_messages_topic_id, emoji, disable_notification, protect_content, allow_paid_broadcast, message_effect_id, suggested_post_parameters, reply_parameters, reply_markup
      Message.from_json res.to_json if res
    end

    def send_message_draft(chat_id : Int,
                           draft_id : Int,
                           text : String? = nil,
                           message_thread_id : Int32? = nil,
                           parse_mode : String? = nil,
                           entities : Array(MessageEntity)? = nil) : Bool?
      res = def_force_request "sendMessageDraft", chat_id, message_thread_id, draft_id, text, parse_mode, entities
      res.as_bool if res
    end

    def send_chat_action(chat_id : Int | String,
                         action : String)
      res = def_request "sendChatAction", chat_id, action
      res.as_bool if res
    end

    def set_message_reaction(chat_id : Int | String,
                             message_id : Int,
                             reaction : Array(ReactionType)? = nil,
                             is_big : Bool? = nil)
      res = def_request "setMessageReaction", chat_id, message_id, reaction, is_big
      res.as_bool if res
    end

    def delete_message_reaction(chat_id : Int | String,
                                message_id : Int,
                                reaction : ReactionType)
      res = def_request "deleteMessageReaction", chat_id, message_id, reaction
      res.as_bool if res
    end

    def delete_all_message_reactions(chat_id : Int | String,
                                     message_id : Int)
      res = def_request "deleteAllMessageReactions", chat_id, message_id
      res.as_bool if res
    end

    def get_user_profile_photos(user_id : Int32,
                                offset : Int32? = nil,
                                limit : Int32? = nil)
      res = def_force_request "getUserProfilePhotos", user_id, offset, limit
      UserProfilePhotos.from_json res.not_nil!.to_json
    end

    def kick_chat_member(chat_id : Int | String,
                         user_id : Int,
                         until_date : Int? = nil)
      res = def_request "kickChatMember", chat_id, user_id, until_date
      res.as_bool if res
    end

    def unban_chat_member(chat_id : Int | String,
                          user_id : Int32)
      res = def_request "unbanChatMember", chat_id, user_id
      res.as_bool if res
    end

    def restrict_chat_member(chat_id : Int | String,
                             user_id : Int,
                             until_date : Int? = nil,
                             can_send_messages : Bool? = nil,
                             can_send_media_messages : Bool? = nil,
                             can_send_other_messages : Bool? = nil,
                             can_add_web_page_previews : Bool? = nil,
                             permissions : ChatPermissions? = nil,
                             use_independent_chat_permissions : Bool? = nil)
      permissions ||= ChatPermissions.new(
        can_send_messages: can_send_messages,
        can_send_audios: can_send_media_messages,
        can_send_documents: can_send_media_messages,
        can_send_photos: can_send_media_messages,
        can_send_videos: can_send_media_messages,
        can_send_video_notes: can_send_media_messages,
        can_send_voice_notes: can_send_media_messages,
        can_send_other_messages: can_send_other_messages,
        can_add_web_page_previews: can_add_web_page_previews
      )
      res = def_request "restrictChatMember", chat_id, user_id, permissions, use_independent_chat_permissions, until_date
      res.as_bool if res
    end

    def promote_chat_member(chat_id : Int | String,
                            user_id : Int,
                            can_change_info : Bool? = nil,
                            can_post_messages : Bool? = nil,
                            can_edit_messages : Bool? = nil,
                            can_delete_messages : Bool? = nil,
                            can_invite_users : Bool? = nil,
                            can_restrict_members : Bool? = nil,
                            can_pin_messages : Bool? = nil,
                            can_promote_members : Bool? = nil)
      res = def_request "promoteChatMember", chat_id, user_id, can_change_info, can_post_messages, can_edit_messages, can_delete_messages, can_invite_users, can_restrict_members, can_pin_messages, can_promote_members
      res.as_bool if res
    end

    def export_chat_invite_link(chat_id : Int | String)
      res = def_request "exportChatInviteLink", chat_id
      res if res
    end

    def create_chat_invite_link(chat_id : Int | String,
                                name : String? = nil,
                                expire_date : Int? = nil,
                                member_limit : Int32? = nil,
                                creates_join_request : Bool? = nil) : ChatInviteLink?
      res = def_request "createChatInviteLink", chat_id, name, expire_date, member_limit, creates_join_request
      ChatInviteLink.from_json res.to_json if res
    end

    def edit_chat_invite_link(chat_id : Int | String,
                              invite_link : String,
                              name : String? = nil,
                              expire_date : Int? = nil,
                              member_limit : Int32? = nil,
                              creates_join_request : Bool? = nil) : ChatInviteLink?
      res = def_request "editChatInviteLink", chat_id, invite_link, name, expire_date, member_limit, creates_join_request
      ChatInviteLink.from_json res.to_json if res
    end

    def create_chat_subscription_invite_link(chat_id : Int | String,
                                             subscription_period : Int,
                                             subscription_price : Int,
                                             name : String? = nil) : ChatInviteLink?
      res = def_request "createChatSubscriptionInviteLink", chat_id, name, subscription_period, subscription_price
      ChatInviteLink.from_json res.to_json if res
    end

    def edit_chat_subscription_invite_link(chat_id : Int | String,
                                           invite_link : String,
                                           name : String? = nil) : ChatInviteLink?
      res = def_request "editChatSubscriptionInviteLink", chat_id, invite_link, name
      ChatInviteLink.from_json res.to_json if res
    end

    def revoke_chat_invite_link(chat_id : Int | String,
                                invite_link : String) : ChatInviteLink?
      res = def_request "revokeChatInviteLink", chat_id, invite_link
      ChatInviteLink.from_json res.to_json if res
    end

    def approve_chat_join_request(chat_id : Int | String,
                                  user_id : Int)
      res = def_request "approveChatJoinRequest", chat_id, user_id
      res.as_bool if res
    end

    def decline_chat_join_request(chat_id : Int | String,
                                  user_id : Int)
      res = def_request "declineChatJoinRequest", chat_id, user_id
      res.as_bool if res
    end

    def set_chat_photo(chat_id : Int | String, photo : ::File)
      res = def_request "setChatPhoto", chat_id, photo
      res.as_bool if res
    end

    def delete_chat_photo(chat_id : Int | String)
      res = def_request "deleteChatPhoto", chat_id
      res.as_bool if res
    end

    def set_chat_title(chat_id : Int | String, title : String)
      res = def_request "setChatTitle", chat_id, title
      res.as_bool if res
    end

    def set_chat_description(chat_id : Int | String, description : String)
      res = def_request "setChatDescription", chat_id, description
      res.as_bool if res
    end

    def pin_chat_message(chat_id : Int | String, message_id : Int, disable_notification : Bool? = nil)
      res = def_request "pinChatMessage", chat_id, message_id, disable_notification
      res.as_bool if res
    end

    def unpin_chat_message(chat_id : Int | String)
      res = def_request "unpinChatMessage", chat_id
      res.as_bool if res
    end

    def get_chat(chat_id : Int | String)
      res = def_request "getChat", chat_id
      Chat.from_json res.not_nil!.to_json
    end

    def leave_chat(chat_id : Int | String)
      res = def_request "leaveChat", chat_id
      res.as_bool if res
    end

    def get_chat_administrators(chat_id : Int | String)
      res = def_request "getChatAdministrators", chat_id
      res = res.not_nil!.as_a
      admins = Array(ChatMember).new
      res.each { |m| admins << ChatMember.from_json(m.to_json) }
      admins
    end

    def get_chat_member(chat_id : Int | String,
                        user_id : Int32)
      res = def_request "getChatMember", chat_id, user_id
      ChatMember.from_json res.not_nil!.to_json
    end

    def get_chat_members_count(chat_id : Int | String)
      res = def_request "getChatMembersCount", chat_id
      res.as_i if res
    end

    def set_chat_sticker_set(chat_id : Int | String, sticker_set_name : String)
      res = def_request "setChatStickerSet", chat_id, sticker_set_name
      res.as_bool if res
    end

    def delete_chat_sticker_set(chat_id : Int | String)
      res = def_request "deleteChatStickerSet", chat_id
      res.as_bool if res
    end

    def get_forum_topic_icon_stickers : Array(Sticker)
      res = request "getForumTopicIconStickers", force_http: true
      res = res.not_nil!.as_a
      stickers = Array(Sticker).new
      res.each { |sticker| stickers << Sticker.from_json(sticker.to_json) }
      stickers
    end

    def create_forum_topic(chat_id : Int | String,
                           name : String,
                           icon_color : Int32? = nil,
                           icon_custom_emoji_id : String? = nil) : ForumTopic?
      res = def_request "createForumTopic", chat_id, name, icon_color, icon_custom_emoji_id
      ForumTopic.from_json res.to_json if res
    end

    def edit_forum_topic(chat_id : Int | String,
                         message_thread_id : Int,
                         name : String? = nil,
                         icon_custom_emoji_id : String? = nil)
      res = def_request "editForumTopic", chat_id, message_thread_id, name, icon_custom_emoji_id
      res.as_bool if res
    end

    def close_forum_topic(chat_id : Int | String,
                          message_thread_id : Int)
      res = def_request "closeForumTopic", chat_id, message_thread_id
      res.as_bool if res
    end

    def reopen_forum_topic(chat_id : Int | String,
                           message_thread_id : Int)
      res = def_request "reopenForumTopic", chat_id, message_thread_id
      res.as_bool if res
    end

    def delete_forum_topic(chat_id : Int | String,
                           message_thread_id : Int)
      res = def_request "deleteForumTopic", chat_id, message_thread_id
      res.as_bool if res
    end

    def unpin_all_forum_topic_messages(chat_id : Int | String,
                                       message_thread_id : Int)
      res = def_request "unpinAllForumTopicMessages", chat_id, message_thread_id
      res.as_bool if res
    end

    def edit_general_forum_topic(chat_id : Int | String,
                                 name : String)
      res = def_request "editGeneralForumTopic", chat_id, name
      res.as_bool if res
    end

    def close_general_forum_topic(chat_id : Int | String)
      res = def_request "closeGeneralForumTopic", chat_id
      res.as_bool if res
    end

    def reopen_general_forum_topic(chat_id : Int | String)
      res = def_request "reopenGeneralForumTopic", chat_id
      res.as_bool if res
    end

    def hide_general_forum_topic(chat_id : Int | String)
      res = def_request "hideGeneralForumTopic", chat_id
      res.as_bool if res
    end

    def unhide_general_forum_topic(chat_id : Int | String)
      res = def_request "unhideGeneralForumTopic", chat_id
      res.as_bool if res
    end

    def unpin_all_general_forum_topic_messages(chat_id : Int | String)
      res = def_request "unpinAllGeneralForumTopicMessages", chat_id
      res.as_bool if res
    end

    def answer_callback_query(callback_query_id : String,
                              text : String? = nil,
                              show_alert : Bool? = nil,
                              url : String? = nil,
                              cache_time : Int32? = nil)
      res = def_request "answerCallbackQuery", callback_query_id, text, show_alert, url, cache_time
      res.as_bool if res
    end

    def edit_message_text(chat_id : Int | String? = nil,
                          message_id : Int32? = nil,
                          inline_message_id : String? = nil,
                          text : String? = nil,
                          parse_mode : String? = nil,
                          disable_web_page_preview : Bool? = nil,
                          reply_markup : InlineKeyboardMarkup? = nil) : Message | Bool?
      res = def_request "editMessageText", chat_id, message_id, inline_message_id, text, parse_mode, disable_web_page_preview, reply_markup
      if res
        if res.as_bool?
          true
        else
          Message.from_json res.to_json
        end
      end
    end

    def edit_message_caption(chat_id : Int | String? = nil,
                             message_id : Int32? = nil,
                             inline_message_id : String? = nil,
                             caption : String? = nil,
                             reply_markup : InlineKeyboardMarkup? = nil) : Message | Bool?
      res = def_request "editMessageCaption", chat_id, message_id, inline_message_id, caption, reply_markup
      if res
        if res.as_bool?
          true
        else
          Message.from_json res.to_json
        end
      end
    end

    def edit_message_reply_markup(chat_id : Int | String? = nil,
                                  message_id : Int32? = nil,
                                  inline_message_id : String? = nil,
                                  reply_markup : InlineKeyboardMarkup? = nil) : Message | Bool?
      res = def_request "editMessageReplyMarkup", chat_id, message_id, inline_message_id, reply_markup
      if res
        if res.as_bool?
          true
        else
          Message.from_json res.to_json
        end
      end
    end

    def delete_message(chat_id : Int | String,
                       message_id : Int32) : Message | Bool?
      res = def_request "deleteMessage", chat_id, message_id
      if res
        if res.as_bool?
          true
        else
          Message.from_json res.to_json
        end
      end
    end

    def answer_inline_query(inline_query_id : String,
                            results : Array(InlineQueryResult),
                            cache_time : Int32? = nil,
                            is_personal : Bool? = nil,
                            next_offset : String? = nil,
                            switch_pm_text : String? = nil,
                            switch_pm_parameter : String? = nil) : Bool?
      # results   Array of InlineQueryResult  Yes   A JSON-serialized array of results for the inline query
      res = def_request "answerInlineQuery", inline_query_id, cache_time, is_personal, next_offset, results, switch_pm_text, switch_pm_parameter
      res.as_bool if res
    end

    def answer_web_app_query(web_app_query_id : String,
                             result : InlineQueryResult) : SentWebAppMessage
      res = def_request "answerWebAppQuery", web_app_query_id, result
      SentWebAppMessage.from_json(res.to_json)
    end

    def save_prepared_inline_message(user_id : Int,
                                     result : InlineQueryResult,
                                     allow_user_chats : Bool? = nil,
                                     allow_bot_chats : Bool? = nil,
                                     allow_group_chats : Bool? = nil,
                                     allow_channel_chats : Bool? = nil) : PreparedInlineMessage
      res = def_request "savePreparedInlineMessage", user_id, result, allow_user_chats, allow_bot_chats, allow_group_chats, allow_channel_chats
      PreparedInlineMessage.from_json(res.to_json)
    end

    def save_prepared_keyboard_button(user_id : Int,
                                      button : KeyboardButton) : PreparedKeyboardButton
      res = def_request "savePreparedKeyboardButton", user_id, button
      PreparedKeyboardButton.from_json(res.to_json)
    end

    def get_file(file_id : String) : File
      res = def_force_request "getFile", file_id
      File.from_json(res.to_json)
    end

    def download(media)
      download(get_file(media.file_id))
    end

    def download(file : File)
      file.file_path.try { |path| download(path) }
    end

    def download(file_path : String)
      HTTP::Client.get("https://api.telegram.org/file/bot#{@token}/#{file_path}").body
    end

    def set_webhook(url : String,
                    certificate : ::File | String? = nil,
                    max_connections : Int32? = nil,
                    allowed_updates : Array(String)? = @allowed_updates,
                    ip_address : String? = nil,
                    drop_pending_updates : Bool? = nil,
                    secret_token : String? = nil)
      multipart_params = HTTP::Client::MultipartBody.new(serialize_params({
        "url"                  => url,
        "max_connections"      => max_connections,
        "allowed_updates"      => allowed_updates,
        "ip_address"           => ip_address,
        "drop_pending_updates" => drop_pending_updates,
        "secret_token"         => secret_token,
      }))
      multipart_params.add_file("certificate", certificate, filename: "cert.pem") if certificate
      Log.info { "Setting webhook to '#{url}'#{" with certificate" if certificate}" }
      response = HttpClient.new(@token).post_multipart "setWebhook", multipart_params
      handle_http_response(response)
    end

    def delete_webhook(drop_pending_updates : Bool? = nil) : Bool?
      res = def_force_request "deleteWebhook", drop_pending_updates
      res.as_bool if res
    end

    def get_webhook_info : WebhookInfo
      res = request "getWebhookInfo", force_http: true
      WebhookInfo.from_json(res.to_json)
    end

    def get_available_gifts : Gifts
      res = request "getAvailableGifts", force_http: true
      Gifts.from_json(res.to_json)
    end

    def send_gift(gift_id : String,
                  user_id : Int? = nil,
                  chat_id : Int | String? = nil,
                  pay_for_upgrade : Bool? = nil,
                  text : String? = nil,
                  text_parse_mode : String? = nil,
                  text_entities : Array(MessageEntity)? = nil)
      res = def_force_request "sendGift", user_id, chat_id, gift_id, pay_for_upgrade, text, text_parse_mode, text_entities
      res.as_bool if res
    end

    def gift_premium_subscription(user_id : Int,
                                  month_count : Int,
                                  star_count : Int,
                                  text : String? = nil,
                                  text_parse_mode : String? = nil,
                                  text_entities : Array(MessageEntity)? = nil)
      res = def_force_request "giftPremiumSubscription", user_id, month_count, star_count, text, text_parse_mode, text_entities
      res.as_bool if res
    end

    def answer_guest_query(guest_query_id : String,
                           result : InlineQueryResult) : SentGuestMessage
      res = def_request "answerGuestQuery", guest_query_id, result
      SentGuestMessage.from_json(res.to_json)
    end

    def get_business_connection(business_connection_id : String) : BusinessConnection
      res = def_force_request "getBusinessConnection", business_connection_id
      BusinessConnection.from_json(res.to_json)
    end

    def read_business_message(business_connection_id : String,
                              chat_id : Int | String,
                              message_id : Int)
      res = def_force_request "readBusinessMessage", business_connection_id, chat_id, message_id
      res.as_bool if res
    end

    def delete_business_messages(business_connection_id : String,
                                 message_ids : Array(Int32))
      res = def_force_request "deleteBusinessMessages", business_connection_id, message_ids
      res.as_bool if res
    end

    def set_business_account_name(business_connection_id : String,
                                  first_name : String,
                                  last_name : String? = nil)
      res = def_force_request "setBusinessAccountName", business_connection_id, first_name, last_name
      res.as_bool if res
    end

    def set_business_account_username(business_connection_id : String,
                                      username : String? = nil)
      res = def_force_request "setBusinessAccountUsername", business_connection_id, username
      res.as_bool if res
    end

    def set_business_account_bio(business_connection_id : String,
                                 bio : String? = nil)
      res = def_force_request "setBusinessAccountBio", business_connection_id, bio
      res.as_bool if res
    end

    def set_business_account_profile_photo(business_connection_id : String,
                                           photo : InputProfilePhoto,
                                           is_public : Bool? = nil)
      res = def_force_request "setBusinessAccountProfilePhoto", business_connection_id, photo, is_public
      res.as_bool if res
    end

    def remove_business_account_profile_photo(business_connection_id : String,
                                              is_public : Bool? = nil)
      res = def_force_request "removeBusinessAccountProfilePhoto", business_connection_id, is_public
      res.as_bool if res
    end

    def set_business_account_gift_settings(business_connection_id : String,
                                           show_gift_button : Bool,
                                           accepted_gift_types : AcceptedGiftTypes)
      res = def_force_request "setBusinessAccountGiftSettings", business_connection_id, show_gift_button, accepted_gift_types
      res.as_bool if res
    end

    def get_managed_bot_token(user_id : Int) : String
      res = def_force_request "getManagedBotToken", user_id
      res.as_s
    end

    def replace_managed_bot_token(user_id : Int) : String
      res = def_force_request "replaceManagedBotToken", user_id
      res.as_s
    end

    def get_managed_bot_access_settings(user_id : Int) : BotAccessSettings
      res = def_force_request "getManagedBotAccessSettings", user_id
      BotAccessSettings.from_json(res.to_json)
    end

    def set_managed_bot_access_settings(user_id : Int,
                                        is_access_restricted : Bool,
                                        added_user_ids : Array(Int64)? = nil)
      res = def_force_request "setManagedBotAccessSettings", user_id, is_access_restricted, added_user_ids
      res.as_bool if res
    end

    #
    # Games
    #

    def send_game(chat_id : Int | String,
                  game_short_name : String,
                  disable_notification : Bool? = nil,
                  reply_to_message_id : Int32? = nil,
                  reply_markup : InlineKeyboardMarkup? = nil) : Message?
      res = def_request "sendGame", chat_id, game_short_name, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def set_game_score(user_id : Int32,
                       score : Int32,
                       force : Bool? = nil,
                       disable_edit_message : Bool? = nil,
                       chat_id : Int | String? = nil,
                       message_id : Int32? = nil,
                       inline_message_id : String? = nil) : Message | Bool?
      res = def_request "setGameScore", user_id, score, force, disable_edit_message, chat_id, message_id, inline_message_id
      if res
        if res.as_bool?
          true
        else
          Message.from_json res.to_json
        end
      end
    end

    def get_game_high_scores(user_id : Int32,
                             chat_id : Int | String? = nil,
                             message_id : Int32? = nil,
                             inline_message_id : String? = nil) : Array(GameHighScore)
      res = def_request "getGameHighScores", user_id, chat_id, message_id, inline_message_id
      res = res.not_nil!.as_a
      r = Array(GameHighScore).new
      res.each { |score| r << GameHighScore.from_json(score.to_json) }
      r
    end

    #
    # Payments
    #

    def send_invoice(chat_id : Int,
                     title : String,
                     description : String,
                     payload : String,
                     provider_token : String,
                     start_parameter : String,
                     currency : String,
                     prices : Array(LabeledPrice),
                     provider_data : String? = nil,
                     photo_url : String? = nil,
                     photo_size : Int32? = nil,
                     photo_width : Int32? = nil,
                     photo_height : Int32? = nil,
                     need_name : Bool? = nil,
                     need_phone_number : Bool? = nil,
                     need_email : Bool? = nil,
                     need_shipping_address : Bool? = nil,
                     is_flexible : Bool? = nil,
                     disable_notification : Bool? = nil,
                     reply_to_message_id : Int32? = nil,
                     reply_markup : ReplyMarkup = nil) : Message?
      res = def_request "sendInvoice", chat_id, title, description, payload, provider_token, start_parameter, currency, prices, photo_url, photo_size, photo_width, photo_height, need_name, need_phone_number, need_email, need_shipping_address, is_flexible, disable_notification, reply_to_message_id, reply_markup
      Message.from_json res.to_json if res
    end

    def answer_shipping_query(shipping_query_id : String,
                              ok : Bool,
                              shipping_options : Array(ShippingOption)? = nil,
                              error_message : String? = nil) : Bool | Message?
      res = def_request "answerShippingQuery", shipping_query_id, ok, shipping_options, error_message
      res.as_bool if res
    end

    def answer_pre_checkout_query(pre_checkout_query_id : String,
                                  ok : Bool,
                                  error_message : String? = nil) : Bool | Message?
      res = def_request "answerPreCheckoutQuery", pre_checkout_query_id, ok, error_message
      res.as_bool if res
    end

    def get_my_star_balance : StarAmount
      res = request "getMyStarBalance", force_http: true
      StarAmount.from_json(res.to_json)
    end

    def get_star_transactions(offset : Int32? = nil,
                              limit : Int32? = nil) : StarTransactions
      res = def_force_request "getStarTransactions", offset, limit
      StarTransactions.from_json(res.to_json)
    end

    def refund_star_payment(user_id : Int,
                            telegram_payment_charge_id : String)
      res = def_force_request "refundStarPayment", user_id, telegram_payment_charge_id
      res.as_bool if res
    end

    def edit_user_star_subscription(user_id : Int,
                                    telegram_payment_charge_id : String,
                                    is_canceled : Bool)
      res = def_force_request "editUserStarSubscription", user_id, telegram_payment_charge_id, is_canceled
      res.as_bool if res
    end

    #
    # Stickers
    #

    def get_sticker_set(name : String)
      res = def_request "getStickerSet", name
      StickerSet.from_json res.to_json if res
    end

    def upload_sticker_file(user_id : Int, png_sticker : ::File)
      res = def_request "uploadStickerFile", user_id, png_sticker
      File.from_json res.to_json if res
    end

    def create_new_sticker_set(user_id : Int,
                               name : String,
                               title : String,
                               png_sticker : ::File | String,
                               emojis : String,
                               contains_masks : Bool? = nil,
                               mask_position : MaskPosition? = nil)
      res = def_request "createNewStickerSet", user_id, name, title, png_sticker, emojis, contains_masks, mask_position
      res.as_bool if res
    end

    def add_sticker_to_set(user_id : Int,
                           name : String,
                           png_sticker : ::File | String,
                           emojis : String,
                           mask_position : MaskPosition? = nil)
      res = def_request "addStickerToSet", user_id, name, png_sticker, emojis, mask_position
      res.as_bool if res
    end

    def set_sticker_position_in_set(sticker : String, position : Int)
      res = def_request "setStickerPositionInSet", sticker, position
      res.as_bool if res
    end

    def delete_sticker_position_in_set(sticker : String)
      res = def_request "deleteStickerPositionInSet", sticker
      res.as_bool if res
    end

    # Get the current list of the bot's commands.
    def get_my_commands(scope : BotCommandScope? = nil,
                        language_code : String? = nil) : Array(BotCommand)
      res = def_force_request "getMyCommands", scope, language_code
      res = res.not_nil!.as_a
      commands = Array(BotCommand).new
      res.each { |command| commands << BotCommand.from_json(command.to_json) }
      commands
    end

    # Change the list of the bot's commands.
    def set_my_commands(commands : Array(BotCommand),
                        scope : BotCommandScope? = nil,
                        language_code : String? = nil)
      res = def_request "setMyCommands", commands, scope, language_code
      res.as_bool if res
    end

    def delete_my_commands(scope : BotCommandScope? = nil,
                           language_code : String? = nil)
      res = def_force_request "deleteMyCommands", scope, language_code
      res.as_bool if res
    end

    def set_my_name(name : String? = nil,
                    language_code : String? = nil)
      res = def_force_request "setMyName", name, language_code
      res.as_bool if res
    end

    def get_my_name(language_code : String? = nil) : BotName
      res = def_force_request "getMyName", language_code
      BotName.from_json(res.to_json)
    end

    def set_my_description(description : String? = nil,
                           language_code : String? = nil)
      res = def_force_request "setMyDescription", description, language_code
      res.as_bool if res
    end

    def get_my_description(language_code : String? = nil) : BotDescription
      res = def_force_request "getMyDescription", language_code
      BotDescription.from_json(res.to_json)
    end

    def set_my_short_description(short_description : String? = nil,
                                 language_code : String? = nil)
      res = def_force_request "setMyShortDescription", short_description, language_code
      res.as_bool if res
    end

    def get_my_short_description(language_code : String? = nil) : BotShortDescription
      res = def_force_request "getMyShortDescription", language_code
      BotShortDescription.from_json(res.to_json)
    end

    def set_my_default_administrator_rights(rights : ChatAdministratorRights? = nil,
                                            for_channels : Bool? = nil)
      res = def_force_request "setMyDefaultAdministratorRights", rights, for_channels
      res.as_bool if res
    end

    def get_my_default_administrator_rights(for_channels : Bool? = nil) : ChatAdministratorRights
      res = def_force_request "getMyDefaultAdministratorRights", for_channels
      ChatAdministratorRights.from_json(res.to_json)
    end
  end
end
