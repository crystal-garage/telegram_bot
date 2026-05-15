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

- [x] Add a shared helper for JSON-serializing API parameters that are arrays or
      `JSON::Serializable` objects.
- [x] Ensure `allowed_updates`, media arrays, command arrays, inline results,
      reply markup, and future object parameters are serialized consistently.
- [x] Decide whether to keep form-encoded requests as the default or introduce
      JSON request bodies for non-file requests.
- [x] Improve multipart handling enough for binary-safe file uploads.

## Phase 2: Core Update Dispatch

- [x] Add missing `Update` fields:
  - [x] `shipping_query`
  - [x] `pre_checkout_query`
  - [x] `poll`
  - [x] `poll_answer`
  - [x] `my_chat_member`
  - [x] `chat_member`
  - [x] `chat_join_request`
  - [x] `message_reaction`
  - [x] `message_reaction_count`
  - [x] `business_connection`
  - [x] `business_message`
  - [x] `edited_business_message`
  - [x] `deleted_business_messages`
  - [x] `purchased_paid_media`
  - [x] `chat_boost`
  - [x] `removed_chat_boost`
  - [x] `guest_message`
  - [x] `managed_bot`
- [x] Add overridable handler methods for the update types above.
- [x] Update `handle_update` to dispatch all supported update fields.
- [x] Keep existing handler behavior backward-compatible.

## Phase 3: Modern Core Message Types

- [x] Add or update shared message-related types:
  - [x] `MessageId`
  - [x] `InaccessibleMessage`
  - [x] `MaybeInaccessibleMessage`
  - [x] `ReplyParameters`
  - [x] `TextQuote`
  - [x] `ExternalReplyInfo`
  - [x] `LinkPreviewOptions`
  - [x] `MessageOriginUser`
  - [x] `MessageOriginHiddenUser`
  - [x] `MessageOriginChat`
  - [x] `MessageOriginChannel`
- [x] Expand `Message` with common modern fields:
  - [x] `message_thread_id`
  - [x] `direct_messages_topic`
  - [x] `sender_chat`
  - [x] `sender_boost_count`
  - [x] `sender_business_bot`
  - [x] `business_connection_id`
  - [x] `forward_origin`
  - [x] `is_topic_message`
  - [x] `is_automatic_forward`
  - [x] `reply_to_message`
  - [x] `external_reply`
  - [x] `quote`
  - [x] `reply_to_story`
  - [x] `reply_to_checklist_task_id`
  - [x] `reply_to_poll_option_id`
  - [x] `has_protected_content`
  - [x] `is_from_offline`
  - [x] `is_paid_post`
  - [x] `paid_star_count`
  - [x] `effect_id`
  - [x] `show_caption_above_media`
  - [x] `has_media_spoiler`
  - [x] `reply_markup`
- [x] Expand `MessageEntity` with modern fields:
  - [x] `custom_emoji_id`
  - [x] support documented modern entity types such as `custom_emoji`,
        `blockquote`, `expandable_blockquote`, and `date_time`.

## Phase 4: Common Media And Interaction Types

- [x] Add `Animation` sending support where missing from methods.
- [x] Add `Dice`.
- [x] Add poll types:
  - [x] `Poll`
  - [x] `PollOption`
  - [x] `InputPollOption`
  - [x] `InputPollMedia`
  - [x] `InputPollOptionMedia`
  - [x] `PollAnswer`
  - [x] `PollOptionAdded`
  - [x] `PollOptionDeleted`
- [x] Add reaction types:
  - [x] `ReactionTypeEmoji`
  - [x] `ReactionTypeCustomEmoji`
  - [x] `ReactionTypePaid`
  - [x] `MessageReactionUpdated`
  - [x] `MessageReactionCountUpdated`
  - [x] `ReactionCount`
- [x] Add forum topic service types:
  - [x] `ForumTopic`
  - [x] `ForumTopicCreated`
  - [x] `ForumTopicEdited`
  - [x] `ForumTopicClosed`
  - [x] `ForumTopicReopened`
  - [x] `GeneralForumTopicHidden`
  - [x] `GeneralForumTopicUnhidden`

## Phase 5: Common Sending Methods

- [x] Add `send_animation`.
- [x] Add `send_poll`.
- [x] Add `send_dice`.
- [x] Add `copy_message`.
- [x] Add `copy_messages`.
- [x] Add `forward_messages`.
- [x] Add `send_message_draft`.
- [x] Add shared modern optional params to sending methods:
  - [x] `business_connection_id`
  - [x] `message_thread_id`
  - [x] `direct_messages_topic_id`
  - [x] `parse_mode`
  - [x] `entities`
  - [x] `caption_entities`
  - [x] `link_preview_options`
  - [x] `protect_content`
  - [x] `disable_notification`
  - [x] `reply_parameters`
  - [x] `reply_markup`
  - [x] `message_effect_id`
  - [x] `allow_paid_broadcast`
  - [x] `suggested_post_parameters`
- [x] Add media-specific modern params where applicable:
  - [x] `thumbnail`
  - [x] `cover`
  - [x] `start_timestamp`
  - [x] `has_spoiler`
  - [x] `show_caption_above_media`
  - [x] `supports_streaming`

## Phase 6: Webhook And Bot Metadata Methods

- [x] Add `get_webhook_info` and `WebhookInfo`.
- [x] Extend `set_webhook` with:
  - [x] `ip_address`
  - [x] `drop_pending_updates`
  - [x] `secret_token`
- [x] Extend `delete_webhook` with `drop_pending_updates`.
- [x] Add command scopes:
  - [x] `BotCommandScopeDefault`
  - [x] `BotCommandScopeAllPrivateChats`
  - [x] `BotCommandScopeAllGroupChats`
  - [x] `BotCommandScopeAllChatAdministrators`
  - [x] `BotCommandScopeChat`
  - [x] `BotCommandScopeChatAdministrators`
  - [x] `BotCommandScopeChatMember`
- [x] Extend `set_my_commands` and `get_my_commands` with `scope` and
      `language_code`.
- [x] Add `delete_my_commands`.
- [x] Add bot profile methods and types:
  - [x] `set_my_name`, `get_my_name`, `BotName`
  - [x] `set_my_description`, `get_my_description`, `BotDescription`
  - [x] `set_my_short_description`, `get_my_short_description`,
        `BotShortDescription`
  - [x] `set_my_default_administrator_rights`
  - [x] `get_my_default_administrator_rights`

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

- [x] Expand `InlineKeyboardButton` with:
  - [x] `login_url`
  - [x] `web_app`
  - [x] `switch_inline_query_current_chat`
  - [x] `switch_inline_query_chosen_chat`
  - [x] `copy_text`
  - [x] `callback_game`
  - [x] `pay`
  - [x] `icon_custom_emoji_id`
  - [x] `style`
- [x] Add keyboard/web app types:
  - [x] `LoginUrl`
  - [x] `WebAppInfo`
  - [x] `WebAppData`
  - [x] `SwitchInlineQueryChosenChat`
  - [x] `CopyTextButton`
- [x] Expand `KeyboardButton` with:
  - [x] `request_users`
  - [x] `request_chat`
  - [x] `request_contact`
  - [x] `request_location`
  - [x] `request_poll`
  - [x] `web_app`
  - [x] `request_managed_bot`
  - [x] `icon_custom_emoji_id`
  - [x] `style`
- [x] Add `KeyboardButtonRequestUsers`.
- [x] Add `KeyboardButtonRequestChat`.
- [x] Add `KeyboardButtonPollType`.
- [x] Add `KeyboardButtonRequestManagedBot`.
- [x] Add `answer_web_app_query`.
- [x] Add `SentWebAppMessage`.
- [x] Add `save_prepared_inline_message`.
- [x] Add `PreparedInlineMessage`.
- [x] Add `save_prepared_keyboard_button`.
- [x] Add `PreparedKeyboardButton`.

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

- [x] Update README with the supported Bot API version.
- [x] Document known compatibility behavior for old method arguments like
      `reply_to_message_id` versus `reply_parameters`.
- [x] Add examples for:
  - [x] command bot
  - [x] inline keyboard callback bot
  - [x] poll bot
  - [x] forum topic bot
  - [x] webhook with `secret_token`
- [x] Add a support matrix listing implemented methods and types.
- [x] Decide whether to keep deprecated Telegram API aliases or mark them with
      comments before removal in a future major release.
