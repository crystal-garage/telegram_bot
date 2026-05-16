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
  class Bot
    Log = ::Log.for(self)

    alias MessageHandler = Proc(Message, Nil)
    alias InlineQueryHandler = Proc(InlineQuery, Nil)
    alias ChosenInlineResultHandler = Proc(ChosenInlineResult, Nil)
    alias CallbackQueryHandler = Proc(CallbackQuery, Nil)
    alias BusinessConnectionHandler = Proc(BusinessConnection, Nil)
    alias BusinessMessagesDeletedHandler = Proc(BusinessMessagesDeleted, Nil)
    alias MessageReactionUpdatedHandler = Proc(MessageReactionUpdated, Nil)
    alias MessageReactionCountUpdatedHandler = Proc(MessageReactionCountUpdated, Nil)
    alias ShippingQueryHandler = Proc(ShippingQuery, Nil)
    alias PreCheckoutQueryHandler = Proc(PreCheckoutQuery, Nil)
    alias PaidMediaPurchasedHandler = Proc(PaidMediaPurchased, Nil)
    alias PollHandler = Proc(Poll, Nil)
    alias PollAnswerHandler = Proc(PollAnswer, Nil)
    alias ChatMemberUpdatedHandler = Proc(ChatMemberUpdated, Nil)
    alias ChatJoinRequestHandler = Proc(ChatJoinRequest, Nil)
    alias ChatBoostUpdatedHandler = Proc(ChatBoostUpdated, Nil)
    alias ChatBoostRemovedHandler = Proc(ChatBoostRemoved, Nil)
    alias ManagedBotUpdatedHandler = Proc(ManagedBotUpdated, Nil)

    def initialize(
      @name : String,
      @token : String,
      @allowlist : Array(String)? = nil,
      @blocklist : Array(String)? = nil,
      @updates_timeout : Int32? = nil,
      @allowed_updates : Array(String)? = nil,
    )
      @nextoffset = 0
      @running = false
      @message_handler = nil.as(MessageHandler?)
      @edited_message_handler = nil.as(MessageHandler?)
      @channel_post_handler = nil.as(MessageHandler?)
      @edited_channel_post_handler = nil.as(MessageHandler?)
      @inline_query_handler = nil.as(InlineQueryHandler?)
      @chosen_inline_result_handler = nil.as(ChosenInlineResultHandler?)
      @callback_query_handler = nil.as(CallbackQueryHandler?)
      @business_connection_handler = nil.as(BusinessConnectionHandler?)
      @business_message_handler = nil.as(MessageHandler?)
      @edited_business_message_handler = nil.as(MessageHandler?)
      @deleted_business_messages_handler = nil.as(BusinessMessagesDeletedHandler?)
      @guest_message_handler = nil.as(MessageHandler?)
      @message_reaction_handler = nil.as(MessageReactionUpdatedHandler?)
      @message_reaction_count_handler = nil.as(MessageReactionCountUpdatedHandler?)
      @shipping_query_handler = nil.as(ShippingQueryHandler?)
      @pre_checkout_query_handler = nil.as(PreCheckoutQueryHandler?)
      @purchased_paid_media_handler = nil.as(PaidMediaPurchasedHandler?)
      @poll_handler = nil.as(PollHandler?)
      @poll_answer_handler = nil.as(PollAnswerHandler?)
      @my_chat_member_handler = nil.as(ChatMemberUpdatedHandler?)
      @chat_member_handler = nil.as(ChatMemberUpdatedHandler?)
      @chat_join_request_handler = nil.as(ChatJoinRequestHandler?)
      @chat_boost_handler = nil.as(ChatBoostUpdatedHandler?)
      @removed_chat_boost_handler = nil.as(ChatBoostRemovedHandler?)
      @managed_bot_handler = nil.as(ManagedBotUpdatedHandler?)
    end
  end
end

require "./bot/requests"
require "./bot/updates"
require "./bot/methods/sending"
require "./bot/methods/chat"
require "./bot/methods/inline"
require "./bot/methods/files"
require "./bot/methods/webhooks"
require "./bot/methods/gifts_business"
require "./bot/methods/games"
require "./bot/methods/payments"
require "./bot/methods/stickers"
require "./bot/methods/profile"
