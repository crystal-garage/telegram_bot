# Telegram Bot API Upgrade TODO

This shard currently targets an old Telegram Bot API surface. Use this plan to
upgrade it in small, reviewable steps. Prefer adding focused specs per step and
keeping backward-compatible method signatures where practical.

## Phase 0: Existing Wrapper Fixes

- [x] Fix `send_photo` so it sends `caption`.
- [x] Fix `send_audio` to call `sendAudio`, not `sendPhoto`.
- [x] Fix `send_video_note` to send the `video_note` parameter and remove
      references to unrelated variables.
- [x] Fix `send_invoice` typo so the public argument and submitted parameter are
      `title`, not `tilte`.
- [x] Fix `send_contact` to expose and send `disable_notification` if supported
      by the local wrapper.
- [x] Review duplicate/obsolete wrappers in `bot.cr` such as duplicate
      `pin_chat_message` and `unpin_chat_message`.
- [x] Dispatch payment query updates already present in `Update`:
  - [x] `shipping_query`
  - [x] `pre_checkout_query`
- [x] Fix `answer_shipping_query` to send `shipping_options`.
- [x] Add focused request-building specs for the fixed methods.

## Phase 1: Request Serialization Foundation

- [ ] Add a shared helper for JSON-serializing API parameters that are arrays or
      `JSON::Serializable` objects.
- [ ] Ensure `allowed_updates`, media arrays, command arrays, inline results,
      reply markup, and future object parameters are serialized consistently.
- [ ] Decide whether to keep form-encoded requests as the default or introduce
      JSON request bodies for non-file requests.
- [ ] Improve multipart handling enough for binary-safe file uploads.

## Phase 2: Core Update Dispatch

- [ ] Add missing `Update` fields:
  - [ ] `shipping_query`
  - [ ] `pre_checkout_query`
  - [ ] `poll`
  - [ ] `poll_answer`
  - [ ] `my_chat_member`
  - [ ] `chat_member`
  - [ ] `chat_join_request`
  - [ ] `message_reaction`
  - [ ] `message_reaction_count`
  - [ ] `business_connection`
  - [ ] `business_message`
  - [ ] `edited_business_message`
  - [ ] `deleted_business_messages`
  - [ ] `purchased_paid_media`
  - [ ] `chat_boost`
  - [ ] `removed_chat_boost`
  - [ ] `guest_message`
  - [ ] `managed_bot`
- [ ] Add overridable handler methods for the update types above.
- [ ] Update `handle_update` to dispatch all supported update fields.
- [ ] Keep existing handler behavior backward-compatible.

## Phase 3: Modern Core Message Types

- [ ] Add or update shared message-related types:
  - [ ] `MessageId`
  - [ ] `InaccessibleMessage`
  - [ ] `MaybeInaccessibleMessage`
  - [ ] `ReplyParameters`
  - [ ] `TextQuote`
  - [ ] `ExternalReplyInfo`
  - [ ] `LinkPreviewOptions`
  - [ ] `MessageOriginUser`
  - [ ] `MessageOriginHiddenUser`
  - [ ] `MessageOriginChat`
  - [ ] `MessageOriginChannel`
- [ ] Expand `Message` with common modern fields:
  - [ ] `message_thread_id`
  - [ ] `direct_messages_topic`
  - [ ] `sender_chat`
  - [ ] `sender_boost_count`
  - [ ] `sender_business_bot`
  - [ ] `business_connection_id`
  - [ ] `forward_origin`
  - [ ] `is_topic_message`
  - [ ] `is_automatic_forward`
  - [ ] `reply_to_message`
  - [ ] `external_reply`
  - [ ] `quote`
  - [ ] `reply_to_story`
  - [ ] `reply_to_checklist_task_id`
  - [ ] `reply_to_poll_option_id`
  - [ ] `has_protected_content`
  - [ ] `is_from_offline`
  - [ ] `is_paid_post`
  - [ ] `paid_star_count`
  - [ ] `effect_id`
  - [ ] `show_caption_above_media`
  - [ ] `has_media_spoiler`
  - [ ] `reply_markup`
- [ ] Expand `MessageEntity` with modern fields:
  - [ ] `custom_emoji_id`
  - [ ] support documented modern entity types such as `custom_emoji`,
        `blockquote`, `expandable_blockquote`, and `date_time`.

## Phase 4: Common Media And Interaction Types

- [ ] Add `Animation` sending support where missing from methods.
- [ ] Add `Dice`.
- [ ] Add poll types:
  - [ ] `Poll`
  - [ ] `PollOption`
  - [ ] `InputPollOption`
  - [ ] `InputPollMedia`
  - [ ] `InputPollOptionMedia`
  - [ ] `PollAnswer`
  - [ ] `PollOptionAdded`
  - [ ] `PollOptionDeleted`
- [ ] Add reaction types:
  - [ ] `ReactionTypeEmoji`
  - [ ] `ReactionTypeCustomEmoji`
  - [ ] `ReactionTypePaid`
  - [ ] `MessageReactionUpdated`
  - [ ] `MessageReactionCountUpdated`
  - [ ] `ReactionCount`
- [ ] Add forum topic service types:
  - [ ] `ForumTopic`
  - [ ] `ForumTopicCreated`
  - [ ] `ForumTopicEdited`
  - [ ] `ForumTopicClosed`
  - [ ] `ForumTopicReopened`
  - [ ] `GeneralForumTopicHidden`
  - [ ] `GeneralForumTopicUnhidden`

## Phase 5: Common Sending Methods

- [ ] Add `send_animation`.
- [ ] Add `send_poll`.
- [ ] Add `send_dice`.
- [ ] Add `copy_message`.
- [ ] Add `copy_messages`.
- [ ] Add `forward_messages`.
- [ ] Add `send_message_draft`.
- [ ] Add shared modern optional params to sending methods:
  - [ ] `business_connection_id`
  - [ ] `message_thread_id`
  - [ ] `direct_messages_topic_id`
  - [ ] `parse_mode`
  - [ ] `entities`
  - [ ] `caption_entities`
  - [ ] `link_preview_options`
  - [ ] `protect_content`
  - [ ] `disable_notification`
  - [ ] `reply_parameters`
  - [ ] `reply_markup`
  - [ ] `message_effect_id`
  - [ ] `allow_paid_broadcast`
  - [ ] `suggested_post_parameters`
- [ ] Add media-specific modern params where applicable:
  - [ ] `thumbnail`
  - [ ] `cover`
  - [ ] `start_timestamp`
  - [ ] `has_spoiler`
  - [ ] `show_caption_above_media`
  - [ ] `supports_streaming`

## Phase 6: Webhook And Bot Metadata Methods

- [ ] Add `get_webhook_info` and `WebhookInfo`.
- [ ] Extend `set_webhook` with:
  - [ ] `ip_address`
  - [ ] `drop_pending_updates`
  - [ ] `secret_token`
- [ ] Extend `delete_webhook` with `drop_pending_updates`.
- [ ] Add command scopes:
  - [ ] `BotCommandScopeDefault`
  - [ ] `BotCommandScopeAllPrivateChats`
  - [ ] `BotCommandScopeAllGroupChats`
  - [ ] `BotCommandScopeAllChatAdministrators`
  - [ ] `BotCommandScopeChat`
  - [ ] `BotCommandScopeChatAdministrators`
  - [ ] `BotCommandScopeChatMember`
- [ ] Extend `set_my_commands` and `get_my_commands` with `scope` and
      `language_code`.
- [ ] Add `delete_my_commands`.
- [ ] Add bot profile methods and types:
  - [ ] `set_my_name`, `get_my_name`, `BotName`
  - [ ] `set_my_description`, `get_my_description`, `BotDescription`
  - [ ] `set_my_short_description`, `get_my_short_description`,
        `BotShortDescription`
  - [ ] `set_my_default_administrator_rights`
  - [ ] `get_my_default_administrator_rights`

## Phase 7: Chat Administration

- [ ] Add `ChatPermissions`.
- [ ] Add modern `ChatMember` variants or expand current `ChatMember`:
  - [ ] owner
  - [ ] administrator
  - [ ] member
  - [ ] restricted
  - [ ] left
  - [ ] banned
- [ ] Add `ChatMemberUpdated`.
- [ ] Add `ChatInviteLink`.
- [ ] Add `ChatJoinRequest`.
- [ ] Add invite link methods:
  - [ ] `create_chat_invite_link`
  - [ ] `edit_chat_invite_link`
  - [ ] `create_chat_subscription_invite_link`
  - [ ] `edit_chat_subscription_invite_link`
  - [ ] `revoke_chat_invite_link`
- [ ] Add join request methods:
  - [ ] `approve_chat_join_request`
  - [ ] `decline_chat_join_request`
- [ ] Add forum methods:
  - [ ] `get_forum_topic_icon_stickers`
  - [ ] `create_forum_topic`
  - [ ] `edit_forum_topic`
  - [ ] `close_forum_topic`
  - [ ] `reopen_forum_topic`
  - [ ] `delete_forum_topic`
  - [ ] `unpin_all_forum_topic_messages`
  - [ ] `edit_general_forum_topic`
  - [ ] `close_general_forum_topic`
  - [ ] `reopen_general_forum_topic`
  - [ ] `hide_general_forum_topic`
  - [ ] `unhide_general_forum_topic`
  - [ ] `unpin_all_general_forum_topic_messages`
- [ ] Add reaction methods:
  - [ ] `set_message_reaction`
  - [ ] `delete_message_reaction`
  - [ ] `delete_all_message_reactions`

## Phase 8: Keyboard, Inline, And Web App Support

- [ ] Expand `InlineKeyboardButton` with:
  - [ ] `login_url`
  - [ ] `web_app`
  - [ ] `switch_inline_query_current_chat`
  - [ ] `switch_inline_query_chosen_chat`
  - [ ] `copy_text`
  - [ ] `callback_game`
  - [ ] `pay`
  - [ ] `icon_custom_emoji_id`
  - [ ] `style`
- [ ] Add keyboard/web app types:
  - [ ] `LoginUrl`
  - [ ] `WebAppInfo`
  - [ ] `WebAppData`
  - [ ] `SwitchInlineQueryChosenChat`
  - [ ] `CopyTextButton`
- [ ] Expand `KeyboardButton` with:
  - [ ] `request_users`
  - [ ] `request_chat`
  - [ ] `request_contact`
  - [ ] `request_location`
  - [ ] `request_poll`
  - [ ] `web_app`
  - [ ] `request_managed_bot`
  - [ ] `icon_custom_emoji_id`
  - [ ] `style`
- [ ] Add `KeyboardButtonRequestUsers`.
- [ ] Add `KeyboardButtonRequestChat`.
- [ ] Add `KeyboardButtonPollType`.
- [ ] Add `KeyboardButtonRequestManagedBot`.
- [ ] Add `answer_web_app_query`.
- [ ] Add `SentWebAppMessage`.
- [ ] Add `save_prepared_inline_message`.
- [ ] Add `PreparedInlineMessage`.
- [ ] Add `save_prepared_keyboard_button`.
- [ ] Add `PreparedKeyboardButton`.

## Phase 9: Payments, Stars, Gifts, Paid Media

- [ ] Add modern payment fields:
  - [ ] `RefundedPayment`
  - [ ] `RevenueWithdrawalState`
  - [ ] `TransactionPartner`
  - [ ] `StarTransaction`
  - [ ] `StarTransactions`
  - [ ] `StarAmount`
- [ ] Add paid media types:
  - [ ] `PaidMediaInfo`
  - [ ] `PaidMediaPreview`
  - [ ] `PaidMediaPhoto`
  - [ ] `PaidMediaVideo`
  - [ ] `PaidMediaLivePhoto`
  - [ ] `InputPaidMediaPhoto`
  - [ ] `InputPaidMediaVideo`
  - [ ] `InputPaidMediaLivePhoto`
- [ ] Add paid media methods:
  - [ ] `send_paid_media`
  - [ ] `get_star_transactions`
  - [ ] `refund_star_payment`
  - [ ] `edit_user_star_subscription`
- [ ] Add gift types and methods if needed by downstream users.

## Phase 10: Business, Guest, And Managed Bot Support

- [ ] Add business connection types:
  - [ ] `BusinessConnection`
  - [ ] `BusinessMessagesDeleted`
  - [ ] `BusinessBotRights`
  - [ ] `BusinessIntro`
  - [ ] `BusinessLocation`
  - [ ] `BusinessOpeningHours`
- [ ] Add business methods:
  - [ ] `get_business_connection`
  - [ ] `read_business_message`
  - [ ] `delete_business_messages`
  - [ ] `set_business_account_name`
  - [ ] `set_business_account_username`
  - [ ] `set_business_account_bio`
  - [ ] `set_business_account_profile_photo`
  - [ ] `remove_business_account_profile_photo`
  - [ ] `set_business_account_gift_settings`
- [ ] Add guest mode support:
  - [ ] `SentGuestMessage`
  - [ ] `answer_guest_query`
- [ ] Add managed bot support:
  - [ ] `ManagedBotUpdated`
  - [ ] `ManagedBotCreated`
  - [ ] `BotAccessSettings`
  - [ ] `get_managed_bot_token`
  - [ ] `replace_managed_bot_token`
  - [ ] `get_managed_bot_access_settings`
  - [ ] `set_managed_bot_access_settings`

## Phase 11: Documentation And Compatibility

- [ ] Update README with the supported Bot API version.
- [ ] Document known compatibility behavior for old method arguments like
      `reply_to_message_id` versus `reply_parameters`.
- [ ] Add examples for:
  - [ ] command bot
  - [ ] inline keyboard callback bot
  - [ ] poll bot
  - [ ] forum topic bot
  - [ ] webhook with `secret_token`
- [ ] Add a support matrix listing implemented methods and types.
- [ ] Decide whether to keep deprecated Telegram API aliases or mark them with
      comments before removal in a future major release.
