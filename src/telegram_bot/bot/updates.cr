module TelegramBot
  class Bot
    # Registers a block handler for incoming messages.
    def on_message(&block : Message -> _)
      @message_handler = ->(message : Message) { block.call(message); nil }
    end

    # Registers a block handler for edited messages.
    def on_edited_message(&block : Message -> _)
      @edited_message_handler = ->(message : Message) { block.call(message); nil }
    end

    # Registers a block handler for channel posts.
    def on_channel_post(&block : Message -> _)
      @channel_post_handler = ->(message : Message) { block.call(message); nil }
    end

    # Registers a block handler for edited channel posts.
    def on_edited_channel_post(&block : Message -> _)
      @edited_channel_post_handler = ->(message : Message) { block.call(message); nil }
    end

    # Registers a block handler for inline queries.
    def on_inline_query(&block : InlineQuery -> _)
      @inline_query_handler = ->(inline_query : InlineQuery) { block.call(inline_query); nil }
    end

    # Registers a block handler for chosen inline results.
    def on_chosen_inline_result(&block : ChosenInlineResult -> _)
      @chosen_inline_result_handler = ->(chosen_inline_result : ChosenInlineResult) { block.call(chosen_inline_result); nil }
    end

    # Registers a block handler for callback queries.
    def on_callback_query(&block : CallbackQuery -> _)
      @callback_query_handler = ->(callback_query : CallbackQuery) { block.call(callback_query); nil }
    end

    # Registers a block handler for business connection updates.
    def on_business_connection(&block : BusinessConnection -> _)
      @business_connection_handler = ->(business_connection : BusinessConnection) { block.call(business_connection); nil }
    end

    # Registers a block handler for business messages.
    def on_business_message(&block : Message -> _)
      @business_message_handler = ->(message : Message) { block.call(message); nil }
    end

    # Registers a block handler for edited business messages.
    def on_edited_business_message(&block : Message -> _)
      @edited_business_message_handler = ->(message : Message) { block.call(message); nil }
    end

    # Registers a block handler for deleted business message updates.
    def on_deleted_business_messages(&block : BusinessMessagesDeleted -> _)
      @deleted_business_messages_handler = ->(deleted_business_messages : BusinessMessagesDeleted) { block.call(deleted_business_messages); nil }
    end

    # Registers a block handler for guest messages.
    def on_guest_message(&block : Message -> _)
      @guest_message_handler = ->(message : Message) { block.call(message); nil }
    end

    # Registers a block handler for message reaction updates.
    def on_message_reaction(&block : MessageReactionUpdated -> _)
      @message_reaction_handler = ->(message_reaction : MessageReactionUpdated) { block.call(message_reaction); nil }
    end

    # Registers a block handler for message reaction count updates.
    def on_message_reaction_count(&block : MessageReactionCountUpdated -> _)
      @message_reaction_count_handler = ->(message_reaction_count : MessageReactionCountUpdated) { block.call(message_reaction_count); nil }
    end

    # Registers a block handler for shipping queries.
    def on_shipping_query(&block : ShippingQuery -> _)
      @shipping_query_handler = ->(shipping_query : ShippingQuery) { block.call(shipping_query); nil }
    end

    # Registers a block handler for pre-checkout queries.
    def on_pre_checkout_query(&block : PreCheckoutQuery -> _)
      @pre_checkout_query_handler = ->(pre_checkout_query : PreCheckoutQuery) { block.call(pre_checkout_query); nil }
    end

    # Registers a block handler for purchased paid media updates.
    def on_purchased_paid_media(&block : PaidMediaPurchased -> _)
      @purchased_paid_media_handler = ->(purchased_paid_media : PaidMediaPurchased) { block.call(purchased_paid_media); nil }
    end

    # Registers a block handler for poll updates.
    def on_poll(&block : Poll -> _)
      @poll_handler = ->(poll : Poll) { block.call(poll); nil }
    end

    # Registers a block handler for poll answer updates.
    def on_poll_answer(&block : PollAnswer -> _)
      @poll_answer_handler = ->(poll_answer : PollAnswer) { block.call(poll_answer); nil }
    end

    # Registers a block handler for bot chat member status updates.
    def on_my_chat_member(&block : ChatMemberUpdated -> _)
      @my_chat_member_handler = ->(my_chat_member : ChatMemberUpdated) { block.call(my_chat_member); nil }
    end

    # Registers a block handler for chat member status updates.
    def on_chat_member(&block : ChatMemberUpdated -> _)
      @chat_member_handler = ->(chat_member : ChatMemberUpdated) { block.call(chat_member); nil }
    end

    # Registers a block handler for chat join requests.
    def on_chat_join_request(&block : ChatJoinRequest -> _)
      @chat_join_request_handler = ->(chat_join_request : ChatJoinRequest) { block.call(chat_join_request); nil }
    end

    # Registers a block handler for chat boost updates.
    def on_chat_boost(&block : ChatBoostUpdated -> _)
      @chat_boost_handler = ->(chat_boost : ChatBoostUpdated) { block.call(chat_boost); nil }
    end

    # Registers a block handler for removed chat boost updates.
    def on_removed_chat_boost(&block : ChatBoostRemoved -> _)
      @removed_chat_boost_handler = ->(removed_chat_boost : ChatBoostRemoved) { block.call(removed_chat_boost); nil }
    end

    # Registers a block handler for managed bot updates.
    def on_managed_bot(&block : ManagedBotUpdated -> _)
      @managed_bot_handler = ->(managed_bot : ManagedBotUpdated) { block.call(managed_bot); nil }
    end

    # handle messages
    def handle(message : Message)
      if handler = @message_handler
        return handler.call(message)
      end

      raise "message handler is not implemented"
    end

    # handle edited messages
    def handle_edited(message : Message)
      if handler = @edited_message_handler
        return handler.call(message)
      end

      raise "edited message handler is not implemented"
    end

    def handle_channel_post(message : Message)
      if handler = @channel_post_handler
        return handler.call(message)
      end

      raise "channel post handler is not implemented"
    end

    def handle_edited_channel_post(message : Message)
      if handler = @edited_channel_post_handler
        return handler.call(message)
      end

      raise "edited channel post handler is not implemented"
    end

    # handle inline query
    def handle(inline_query : InlineQuery)
      if handler = @inline_query_handler
        return handler.call(inline_query)
      end

      raise "inline_query handler is not implemented"
    end

    # handle chosen inlien query
    def handle(chosen_inline_result : ChosenInlineResult)
      if handler = @chosen_inline_result_handler
        return handler.call(chosen_inline_result)
      end

      raise "chosen_inline_result handler is not implemented"
    end

    # handle callback query
    def handle(callback_query : CallbackQuery)
      if handler = @callback_query_handler
        return handler.call(callback_query)
      end

      raise "callback_query handler is not implemented"
    end

    # handle business connection updates
    def handle_business_connection(business_connection : BusinessConnection)
      if handler = @business_connection_handler
        return handler.call(business_connection)
      end

      raise "business_connection handler is not implemented"
    end

    # handle business messages
    def handle_business_message(message : Message)
      if handler = @business_message_handler
        return handler.call(message)
      end

      raise "business_message handler is not implemented"
    end

    # handle edited business messages
    def handle_edited_business_message(message : Message)
      if handler = @edited_business_message_handler
        return handler.call(message)
      end

      raise "edited_business_message handler is not implemented"
    end

    # handle deleted business messages
    def handle_deleted_business_messages(deleted_business_messages : BusinessMessagesDeleted)
      if handler = @deleted_business_messages_handler
        return handler.call(deleted_business_messages)
      end

      raise "deleted_business_messages handler is not implemented"
    end

    # handle guest messages
    def handle_guest_message(message : Message)
      if handler = @guest_message_handler
        return handler.call(message)
      end

      raise "guest_message handler is not implemented"
    end

    # handle message reaction updates
    def handle(message_reaction : MessageReactionUpdated)
      if handler = @message_reaction_handler
        return handler.call(message_reaction)
      end

      raise "message_reaction handler is not implemented"
    end

    # handle message reaction count updates
    def handle(message_reaction_count : MessageReactionCountUpdated)
      if handler = @message_reaction_count_handler
        return handler.call(message_reaction_count)
      end

      raise "message_reaction_count handler is not implemented"
    end

    # handle shipping query
    def handle(shipping_query : ShippingQuery)
      if handler = @shipping_query_handler
        return handler.call(shipping_query)
      end

      raise "shipping_query handler is not implemented"
    end

    # handle pre-checkout query
    def handle(pre_checkout_query : PreCheckoutQuery)
      if handler = @pre_checkout_query_handler
        return handler.call(pre_checkout_query)
      end

      raise "pre_checkout_query handler is not implemented"
    end

    # handle purchased paid media updates
    def handle(purchased_paid_media : PaidMediaPurchased)
      if handler = @purchased_paid_media_handler
        return handler.call(purchased_paid_media)
      end

      raise "purchased_paid_media handler is not implemented"
    end

    # handle poll updates
    def handle(poll : Poll)
      if handler = @poll_handler
        return handler.call(poll)
      end

      raise "poll handler is not implemented"
    end

    # handle poll answer updates
    def handle(poll_answer : PollAnswer)
      if handler = @poll_answer_handler
        return handler.call(poll_answer)
      end

      raise "poll_answer handler is not implemented"
    end

    # handle bot chat member status updates
    def handle_my_chat_member(my_chat_member : ChatMemberUpdated)
      if handler = @my_chat_member_handler
        return handler.call(my_chat_member)
      end

      raise "my_chat_member handler is not implemented"
    end

    # handle chat member status updates
    def handle(chat_member : ChatMemberUpdated)
      if handler = @chat_member_handler
        return handler.call(chat_member)
      end

      raise "chat_member handler is not implemented"
    end

    # handle chat join requests
    def handle(chat_join_request : ChatJoinRequest)
      if handler = @chat_join_request_handler
        return handler.call(chat_join_request)
      end

      raise "chat_join_request handler is not implemented"
    end

    # handle chat boost updates
    def handle(chat_boost : ChatBoostUpdated)
      if handler = @chat_boost_handler
        return handler.call(chat_boost)
      end

      raise "chat_boost handler is not implemented"
    end

    # handle removed chat boost updates
    def handle(removed_chat_boost : ChatBoostRemoved)
      if handler = @removed_chat_boost_handler
        return handler.call(removed_chat_boost)
      end

      raise "removed_chat_boost handler is not implemented"
    end

    # handle managed bot updates
    def handle(managed_bot : ManagedBotUpdated)
      if handler = @managed_bot_handler
        return handler.call(managed_bot)
      end

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
