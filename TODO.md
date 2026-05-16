# Pre-1.0 Telegram Bot API Alignment TODO

Goal: before `1.0.0`, align this shard with every current Telegram Bot API method, parameter, object, and field documented at <https://core.telegram.org/bots/api>.

Baseline: Telegram Bot API `10.0`.

Compatibility rule: additions should keep the current library API working. The only intentional breaking changes before `1.0.0` are removing or renaming public methods, parameters, or fields that are deprecated or not documented in the current official Telegram Bot API.

## 1. Method Coverage

Add wrappers for every official Bot API method that is still missing.

### Core

- [x] `log_out` -> `logOut`
- [x] `close` -> `close`

### Sending, Editing, And Deleting Messages

- [x] `send_checklist` -> `sendChecklist`
- [x] `edit_message_media` -> `editMessageMedia`
- [x] `edit_message_checklist` -> `editMessageChecklist`
- [x] `stop_poll` -> `stopPoll`
- [x] `delete_messages` -> `deleteMessages`
- [x] `approve_suggested_post` -> `approveSuggestedPost`
- [x] `decline_suggested_post` -> `declineSuggestedPost`

### Chat Administration

- [x] `set_chat_administrator_custom_title` -> `setChatAdministratorCustomTitle`
- [x] `set_chat_member_tag` -> `setChatMemberTag`
- [x] `ban_chat_sender_chat` -> `banChatSenderChat`
- [x] `unban_chat_sender_chat` -> `unbanChatSenderChat`
- [x] `set_chat_permissions` -> `setChatPermissions`
- [x] `unpin_all_chat_messages` -> `unpinAllChatMessages`
- [x] `get_user_chat_boosts` -> `getUserChatBoosts`

### Bot Profile And Menu

- [x] `set_my_profile_photo` -> `setMyProfilePhoto`
- [x] `remove_my_profile_photo` -> `removeMyProfilePhoto`
- [x] `set_chat_menu_button` -> `setChatMenuButton`
- [x] `get_chat_menu_button` -> `getChatMenuButton`

### Verification

- [x] `verify_user` -> `verifyUser`
- [x] `verify_chat` -> `verifyChat`
- [x] `remove_user_verification` -> `removeUserVerification`
- [x] `remove_chat_verification` -> `removeChatVerification`

### Business, Gifts, And Stories

- [x] `get_business_account_star_balance` -> `getBusinessAccountStarBalance`
- [x] `transfer_business_account_stars` -> `transferBusinessAccountStars`
- [x] `get_business_account_gifts` -> `getBusinessAccountGifts`
- [x] `get_user_gifts` -> `getUserGifts`
- [x] `get_chat_gifts` -> `getChatGifts`
- [x] `convert_gift_to_stars` -> `convertGiftToStars`
- [x] `upgrade_gift` -> `upgradeGift`
- [x] `transfer_gift` -> `transferGift`
- [x] `post_story` -> `postStory`
- [x] `repost_story` -> `repostStory`
- [x] `edit_story` -> `editStory`
- [x] `delete_story` -> `deleteStory`

### Stickers

- [ ] `get_custom_emoji_stickers` -> `getCustomEmojiStickers`
- [ ] `replace_sticker_in_set` -> `replaceStickerInSet`
- [ ] `set_sticker_emoji_list` -> `setStickerEmojiList`
- [ ] `set_sticker_keywords` -> `setStickerKeywords`
- [ ] `set_sticker_mask_position` -> `setStickerMaskPosition`
- [ ] `set_sticker_set_title` -> `setStickerSetTitle`
- [ ] `set_sticker_set_thumbnail` -> `setStickerSetThumbnail`
- [ ] `set_custom_emoji_sticker_set_thumbnail` -> `setCustomEmojiStickerSetThumbnail`
- [ ] `delete_sticker_set` -> `deleteStickerSet`

### Payments And Passport

- [ ] `create_invoice_link` -> `createInvoiceLink`
- [ ] `set_passport_data_errors` -> `setPassportDataErrors`

## 2. Method Parameter Alignment

Audit every implemented method against the official method table.

- [ ] Add support for named multipart attachments referenced from nested JSON via `attach://<file_attach_name>`, as documented in <https://core.telegram.org/bots/api#sending-files>. This is required for objects such as `InputProfilePhoto`, `InputMedia`, `InputSticker`, `InputPaidMedia`, and story content when their file fields are uploaded through multipart/form-data under a custom attachment name.
- [ ] Add every missing documented parameter.
- [ ] Remove every undocumented or deprecated parameter.
- [ ] Keep official parameter names when they are exposed as request parameters.
- [ ] Keep Crystal method names idiomatic while mapping to official method names.
- [ ] Use typed request serialization instead of ad hoc string handling where possible.
- [ ] Add request-building specs for each changed method.
- [ ] Add multipart request specs for every method that accepts uploaded files.
- [ ] Ensure optional parameters are omitted when `nil`.
- [ ] Ensure arrays and nested objects serialize as compact JSON where the current request builder expects strings.

Known high-risk parameter groups:

- [ ] Message sending options: business connection, direct messages topic, message effects, suggested posts, paid broadcast, reply parameters, link preview options.
- [ ] Media options: spoiler flags, caption placement, thumbnails, covers, start timestamps, streaming support, dimensions, duration.
- [ ] Chat administration options: permissions, administrator rights, tags, invite links, join requests, boosts.
- [ ] Payments options: Stars, subscriptions, tips, suggested post payment fields, invoice-link parity.
- [ ] Inline mode options: button fields, chosen chat filters, prepared inline messages, result thumbnails, input message content.
- [ ] Business, gift, story, and paid media options.

## 3. Type And Field Alignment

Audit every official object documented by Telegram.

- [ ] Ensure a Crystal type exists for every documented object.
- [ ] Ensure every documented field exists with the official JSON name.
- [ ] Remove fields that are not documented by the current official API.
- [ ] Keep required fields non-nil unless Telegram documents them as optional.
- [ ] Keep optional fields nilable.
- [ ] Use `property?` consistently for boolean fields.
- [ ] Add parsing specs for required fields, optional fields, and nested objects.
- [ ] Add union dispatch specs for polymorphic object families.
- [ ] Ensure all new types are required from `src/telegram_bot.cr`.

Known high-risk type groups:

- [ ] Updates and handler hook payloads.
- [ ] `User`, `Chat`, `ChatFullInfo`, and related profile objects.
- [ ] `Message`, `MaybeInaccessibleMessage`, service messages, and message-origin objects.
- [ ] Checklists and suggested posts.
- [ ] Direct messages and topic objects.
- [ ] Paid messages, paid media, Stars, gifts, unique gifts, and owned gifts.
- [ ] Business connection, business profile, business messages, and business account objects.
- [ ] Stories.
- [ ] Chat members, administrator rights, permissions, boosts, invite links, and join requests.
- [ ] Reactions.
- [ ] Polls, dice, contacts, venues, locations, and live locations.
- [ ] Stickers, sticker sets, input stickers, masks, and custom emoji.
- [ ] Inline query results, inline keyboard buttons, and input message content.
- [ ] Payments, invoices, shipping, refunds, transactions, and Passport.
- [ ] Games.
- [ ] Web App and Mini App objects.

## 4. Documentation Alignment

- [ ] Add short doc comments for every public API method.
- [ ] Include official method links in the form `# See: <https://core.telegram.org/bots/api#methodname>`.
- [ ] Keep README method/type support lists in sync with the code.
- [ ] Keep README examples compiling against the current API.
- [ ] Avoid claiming full API support until every method, parameter, object, and field audit item is complete.

## 5. Verification Checklist

Run these after each implementation batch.

- [ ] `crystal tool format src spec`
- [ ] `./bin/ameba`
- [ ] `crystal docs`
- [ ] README examples compile against the current API.
- [ ] User-run specs pass.
- [ ] `git diff --check`

Final `1.0.0` gate:

- [ ] Every official method is implemented.
- [ ] Every implemented method has current official parameters only.
- [ ] Every official object and field is represented.
- [ ] No deprecated or undocumented Telegram API surface remains.
- [ ] README support matrix says the shard is fully aligned with the current Telegram Bot API.
