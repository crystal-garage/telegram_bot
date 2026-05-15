module TelegramBot
  abstract class Bot
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

    def serve(
      bind_address : String = "127.0.0.1",
      bind_port : Int32 = 80,
      ssl_certificate_path : String? = nil,
      ssl_key_path : String? = nil,
    )
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
  end
end
