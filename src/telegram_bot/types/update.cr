module TelegramBot
  class Update
    include JSON::Serializable

    property update_id : Int32
    property message : TelegramBot::Message?
    property edited_message : TelegramBot::Message?
    property channel_post : TelegramBot::Message?
    property edited_channel_post : TelegramBot::Message?
    property business_connection : TelegramBot::BusinessConnection?
    property business_message : TelegramBot::Message?
    property edited_business_message : TelegramBot::Message?
    property deleted_business_messages : TelegramBot::BusinessMessagesDeleted?
    property guest_message : TelegramBot::Message?
    property message_reaction : TelegramBot::MessageReactionUpdated?
    property message_reaction_count : TelegramBot::MessageReactionCountUpdated?
    property inline_query : TelegramBot::InlineQuery?
    property chosen_inline_result : TelegramBot::ChosenInlineResult?
    property callback_query : TelegramBot::CallbackQuery?
    property shipping_query : TelegramBot::ShippingQuery?
    property pre_checkout_query : TelegramBot::PreCheckoutQuery?
    property purchased_paid_media : TelegramBot::PaidMediaPurchased?
    property poll : TelegramBot::Poll?
    property poll_answer : TelegramBot::PollAnswer?
    property my_chat_member : TelegramBot::ChatMemberUpdated?
    property chat_member : TelegramBot::ChatMemberUpdated?
    property chat_join_request : TelegramBot::ChatJoinRequest?
    property chat_boost : TelegramBot::ChatBoostUpdated?
    property removed_chat_boost : TelegramBot::ChatBoostRemoved?
    property managed_bot : TelegramBot::ManagedBotUpdated?
  end
end
