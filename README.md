# TelegramBot

[![Crystal CI](https://github.com/crystal-garage/telegram_bot/actions/workflows/crystal.yml/badge.svg)](https://github.com/crystal-garage/telegram_bot/actions/workflows/crystal.yml)
[![GitHub release](https://img.shields.io/github/release/crystal-garage/telegram_bot.svg)](https://github.com/crystal-garage/telegram_bot/releases)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://crystal-garage.github.io/telegram_bot/)
[![License](https://img.shields.io/github/license/crystal-garage/telegram_bot.svg)](https://github.com/crystal-garage/telegram_bot/blob/develop/LICENSE)

[Telegram Bot API](https://core.telegram.org/bots/api) client library for Crystal.

The shard has partial compatibility with Telegram Bot API 10.0. It supports
common messaging, media, chat administration, payments, games, polls, reactions,
keyboards, Web App/Mini App helpers, business features, gifts, and paid media.
See [Bot API support](#bot-api-support) for the current implementation matrix.

> This is a fork of [telegram_bot](https://github.com/hangyas/telegram_bot) which was originally written by Krisztián Ádám.
>
> The original repository is no longer maintained and does not work with the latest Crystal version.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  telegram_bot:
    github: crystal-garage/telegram_bot
```

## Example

A minimal echo bot with long polling:

```crystal
require "telegram_bot"

bot = TelegramBot::Bot.new("echo_bot", ENV["TELEGRAM_BOT_TOKEN"])

bot.on_message do |message|
  next unless text = message.text

  bot.send_message(message.chat.id, "You said: #{text}")
end

bot.polling
```

## Current features

api methods and types:

- [x] basic message types
- [x] stickers
- [x] inline mode
- [x] payments
- [x] games
- [x] polls and dice
- [x] keyboard and Web App helpers
- [x] webhook metadata and command scopes
- [x] bot profile and default administrator-rights methods
- [x] invite link, join request, forum topic, and reaction methods
- [x] Stars, gifts, and paid media methods
- [x] business, guest, and managed bot helpers

getting updates:

- [x] long polling
- [x] webhooks

additional features:

- [x] allow & block lists
- [x] command handler
- [x] block-based update handlers

## Usage

`TelegramBot::Bot` is the high-level client. It exposes Telegram Bot API
methods as Crystal methods, receives updates through `polling` or `serve`, and
can dispatch updates to block handlers or subclass overrides.

### Block handlers

For small bots and scripts, register handlers directly on a bot instance:

```crystal
require "telegram_bot"

bot = TelegramBot::Bot.new("my_bot", ENV["TELEGRAM_BOT_TOKEN"])

bot.on_message do |message|
  next unless text = message.text

  bot.reply(message, text)
end

bot.on_callback_query do |query|
  bot.answer_callback_query(query.id, text: "Received")
end

bot.polling
```

Block handlers are optional. If a handler is not registered, the default
`handle(...)` implementation keeps the existing "handler is not implemented"
behavior.

For structured bots, create your bot by inheriting from `TelegramBot::Bot`.

### Commands

Define which commands your bot handles via the `cmd` method in the `CmdHandler` module. For example, respond `world` to `/hello` and perform simple calculation with `/add`:

```crystal
require "telegram_bot"

class MyBot < TelegramBot::Bot
  include TelegramBot::CmdHandler

  def initialize
    super("MyBot", TOKEN)

    cmd "hello" do |msg|
      reply msg, "world!"
    end

    # /add 5 7 => 12
    cmd "add" do |msg, params|
      reply msg, "#{params[0].to_i + params[1].to_i}"
    end
  end
end

my_bot = MyBot.new
my_bot.polling
```

### Inline keyboard callbacks

Use `InlineKeyboardMarkup` and override `handle(callback_query)` to react to
button presses:

```crystal
class CallbackBot < TelegramBot::Bot
  def handle(message : TelegramBot::Message)
    keyboard = TelegramBot::InlineKeyboardMarkup.new([
      [
        TelegramBot::InlineKeyboardButton.new("Confirm", callback_data: "confirm"),
        TelegramBot::InlineKeyboardButton.new("Open", url: "https://example.com"),
      ],
    ])

    send_message(message.chat.id, "Choose an action", reply_markup: keyboard)
  end

  def handle(callback_query : TelegramBot::CallbackQuery)
    answer_callback_query(callback_query.id, text: "Received")
  end
end
```

### Polls

Use `send_poll` for regular polls and quizzes:

```crystal
class PollBot < TelegramBot::Bot
  def handle(message : TelegramBot::Message)
    options = [
      TelegramBot::InputPollOption.new("Crystal"),
      TelegramBot::InputPollOption.new("Ruby"),
    ]

    send_poll(
      message.chat.id,
      "Which language is compiled?",
      options,
      type: "quiz",
      correct_option_ids: [0]
    )
  end

  def handle(poll_answer : TelegramBot::PollAnswer)
    # Store or inspect poll_answer.option_ids / option_persistent_ids here.
  end
end
```

### Forum topic updates

The shard can parse forum topic service messages. Forum management methods such
as `create_forum_topic` are available as regular Bot API methods.

```crystal
class ForumBot < TelegramBot::Bot
  def handle(message : TelegramBot::Message)
    if topic = message.forum_topic_created
      send_message(message.chat.id, "Topic created: #{topic.name}")
    end
  end
end
```

### Web App and Mini App helpers

Inline and reply keyboard buttons support `web_app`, and the bot can answer Web
App queries:

```crystal
class WebAppBot < TelegramBot::Bot
  def handle(message : TelegramBot::Message)
    if data = message.web_app_data
      return reply message, "Received: #{data.button_text}"
    end

    markup = TelegramBot::InlineKeyboardMarkup.new([
      [
        TelegramBot::InlineKeyboardButton.new(
          "Open app",
          web_app: TelegramBot::WebAppInfo.new("https://example.com/app")
        ),
      ],
    ])

    send_message(message.chat.id, "Open the Mini App", reply_markup: markup)
  end
end
```

### Logging

```crystal
MyBot::Log.level = :debug
MyBot::Log.backend = ::Log::IOBackend.new

my_bot = MyBot.new
my_bot.polling
```

### Subclass handlers

Override any of the following `handle` methods to handle Telegram updates, be it [messages](https://core.telegram.org/bots/api#message), [inline queries](https://core.telegram.org/bots/api#inlinequery), [chosen inline results](https://core.telegram.org/bots/api#choseninlineresult) or [callback queries](https://core.telegram.org/bots/api#callbackquery):

```crystal
def handle(message : TelegramBot::Message)

def handle(inline_query : TelegramBot::InlineQuery)

def handle(chosen_inline_result : TelegramBot::ChosenInlineResult)

def handle(callback_query : TelegramBot::CallbackQuery)

def handle_edited(message : TelegramBot::Message)

def handle_channel_post(message : TelegramBot::Message)

def handle_edited_channel_post(message : TelegramBot::Message)
```

For example, to echo all messages sent to the bot:

```crystal
require "telegram_bot"

class EchoBot < TelegramBot::Bot
  def initialize
    super("echo_bot", ENV["TELEGRAM_BOT_TOKEN"])
  end

  def handle(message : TelegramBot::Message)
    if text = message.text
      reply message, text
    end
  end
end

bot = EchoBot.new
bot.polling
```

Or to answer inline queries with a list of articles:

```crystal
require "telegram_bot"

class InlineBot < TelegramBot::Bot
  def initialize
    super("inline_bot", ENV["TELEGRAM_BOT_TOKEN"])
  end

  def handle(inline_query : TelegramBot::InlineQuery)
    results = Array(TelegramBot::InlineQueryResult).new

    content = TelegramBot::InputTextMessageContent.new("Article details")
    results << TelegramBot::InlineQueryResultArticle.new("article/1", "My first article", content)

    answer_inline_query(inline_query.id, results)
  end
end

bot = InlineBot.new
bot.polling
```

Remember to [enable inline mode](https://core.telegram.org/bots/api#inline-mode) in BotFather to support inline queries.

### Webhooks

All the examples above use the [`getUpdates`](https://core.telegram.org/bots/api#getupdates) method, constantly polling Telegram for new updates, by invoking the `polling` method on the bot.

Another option is to use the [`setWebhook`](https://core.telegram.org/bots/api#setwebhook) method to tell Telegram where to POST any updates for your bot. Note that you __must__ use HTTPS in this endpoint for Telegram to work, and you can use a self-signed certificate, which you can provide as part of the `setWebhook` method:

```crystal
# Certificate has the contents of the certificate, not the path to it
bot.set_webhook(url, certificate)
```

Webhook options can be passed as keyword arguments:

```crystal
bot.set_webhook(
  "https://example.com/telegram",
  secret_token: "secret-token",
  drop_pending_updates: true
)
```

After invoking `setWebhook`, have your bot start an HTTPS server with the `serve` command:

```crystal
bot.serve("0.0.0.0", 443, "path/to/ssl/certificate", "path/to/ssl/key")
```

If you run your bot behind a proxy that performs SSL offloading (ie the proxy presents the certificate to Telegram, and then forwards the request to your app using plain HTTP), you may skip the last two parameters, and the bot will listen for HTTP requests instead of HTTPS.

When running your bot in `serve` mode, the bot will favour executing any methods by sending a response as part of the Telegram request, rather than executing a new request.

`set_webhook` supports Telegram's `secret_token` parameter, but `serve` does not
validate the `X-Telegram-Bot-Api-Secret-Token` header yet. If you need strict
validation, terminate webhooks behind middleware or a proxy that checks the
header before forwarding requests to the bot.

### Low-level API

Most applications should use `TelegramBot::Bot` methods such as `send_message`,
`set_webhook`, `answer_callback_query`, and `polling`.

Request serialization and transport are intentionally lower-level extension
points:

- `TelegramBot::HttpClient` performs Bot API HTTP requests.
- `TelegramBot::ResponseClient` writes method responses into webhook HTTP
  responses when possible.
- `TelegramBot::APIException` is raised for failed Bot API responses.
- `Bot#request`, parameter serialization, and response handling are protected
  internals used by the high-level methods.

Prefer the high-level Bot API methods unless you are extending the shard itself
or testing a custom transport path.

### Allow/blocklists

However it's not part of the API you can set block or allow lists in the bot's constructor to filter your users by username.

`allowlist`: if user is not present on the list (or doesn't have username) the message won't be handled

`blocklist`: if user is present on the list the message won't be handled

## Bot API support

Telegram currently documents Bot API 10.0. This shard is partially upgraded:
implemented items are available through Crystal methods and JSON-serializable
types, while unimplemented items are intentionally left out of the public API.

### Implemented methods

- Messages and media: `send_message`, `reply`, `forward_message`,
  `forward_messages`, `copy_message`, `copy_messages`, `send_photo`,
  `send_audio`, `send_document`, `send_sticker`, `send_video`,
  `send_animation`, `send_voice`, `send_video_note`, `send_media_group`,
  `send_location`, `send_venue`, `send_contact`, `send_poll`, `send_dice`,
  `send_checklist`, `send_message_draft`, `send_chat_action`
- Message editing and deletion: `edit_message_live_location`,
  `stop_message_live_location`, `edit_message_text`, `edit_message_caption`,
  `edit_message_media`, `edit_message_checklist`,
  `edit_message_reply_markup`, `stop_poll`, `delete_message`,
  `delete_messages`, `approve_suggested_post`, `decline_suggested_post`
- Inline and Web App: `answer_inline_query`, `answer_web_app_query`,
  `save_prepared_inline_message`, `save_prepared_keyboard_button`
- Callback, games, files, webhooks: `answer_callback_query`, `send_game`,
  `set_game_score`, `get_game_high_scores`, `get_file`, `download`,
  `set_webhook`, `delete_webhook`, `get_webhook_info`, `serve`
- Chat basics: `ban_chat_member`, `unban_chat_member`,
  `ban_chat_sender_chat`, `unban_chat_sender_chat`,
  `restrict_chat_member`, `set_chat_permissions`, `promote_chat_member`,
  `set_chat_administrator_custom_title`, `set_chat_member_tag`,
  `export_chat_invite_link`,
  `create_chat_invite_link`, `edit_chat_invite_link`,
  `create_chat_subscription_invite_link`,
  `edit_chat_subscription_invite_link`, `revoke_chat_invite_link`,
  `approve_chat_join_request`, `decline_chat_join_request`,
  `set_chat_photo`, `delete_chat_photo`, `set_chat_title`,
  `set_chat_description`, `pin_chat_message`, `unpin_chat_message`,
  `unpin_all_chat_messages`, `get_chat`, `leave_chat`,
  `get_chat_administrators`, `get_chat_member`, `get_user_chat_boosts`,
  `get_chat_member_count`, `set_chat_sticker_set`, `delete_chat_sticker_set`
- Forum and reactions: `get_forum_topic_icon_stickers`,
  `create_forum_topic`, `edit_forum_topic`, `close_forum_topic`,
  `reopen_forum_topic`, `delete_forum_topic`,
  `unpin_all_forum_topic_messages`, `edit_general_forum_topic`,
  `close_general_forum_topic`, `reopen_general_forum_topic`,
  `hide_general_forum_topic`, `unhide_general_forum_topic`,
  `unpin_all_general_forum_topic_messages`, `set_message_reaction`,
  `delete_message_reaction`, `delete_all_message_reactions`
- Payments, Stars, gifts, paid media, and stickers: `send_invoice`,
  `create_invoice_link`, `send_paid_media`, `answer_shipping_query`,
  `answer_pre_checkout_query`, `set_passport_data_errors`,
  `get_my_star_balance`, `get_star_transactions`, `refund_star_payment`,
  `edit_user_star_subscription`, `get_available_gifts`, `send_gift`,
  `gift_premium_subscription`, `get_business_account_star_balance`,
  `transfer_business_account_stars`, `get_business_account_gifts`,
  `get_user_gifts`, `get_chat_gifts`, `convert_gift_to_stars`,
  `upgrade_gift`, `transfer_gift`, `get_sticker_set`, `upload_sticker_file`,
  `get_custom_emoji_stickers`, `create_new_sticker_set`,
  `add_sticker_to_set`, `replace_sticker_in_set`,
  `set_sticker_position_in_set`, `set_sticker_emoji_list`,
  `set_sticker_keywords`, `set_sticker_mask_position`,
  `set_sticker_set_title`, `set_sticker_set_thumbnail`,
  `set_custom_emoji_sticker_set_thumbnail`, `delete_sticker_from_set`,
  `delete_sticker_set`
- Bot commands and profile: `set_my_commands`, `get_my_commands`,
  `delete_my_commands`, `set_my_name`, `get_my_name`, `set_my_description`,
  `get_my_description`, `set_my_short_description`,
  `get_my_short_description`, `set_my_profile_photo`,
  `remove_my_profile_photo`, `set_chat_menu_button`,
  `get_chat_menu_button`, `verify_user`, `verify_chat`,
  `remove_user_verification`, `remove_chat_verification`,
  `set_my_default_administrator_rights`,
  `get_my_default_administrator_rights`
- Business, guest, and managed bots: `get_business_connection`,
  `read_business_message`, `delete_business_messages`,
  `set_business_account_name`, `set_business_account_username`,
  `set_business_account_bio`, `set_business_account_profile_photo`,
  `remove_business_account_profile_photo`,
  `set_business_account_gift_settings`, `answer_guest_query`,
  `post_story`, `repost_story`, `edit_story`, `delete_story`,
  `get_managed_bot_token`, `replace_managed_bot_token`,
  `get_managed_bot_access_settings`, `set_managed_bot_access_settings`

### Implemented update handlers

Override these methods in your bot subclass:

- `handle(message : Message)`
- `handle_edited(message : Message)`
- `handle_channel_post(message : Message)`
- `handle_edited_channel_post(message : Message)`
- `handle(inline_query : InlineQuery)`
- `handle(chosen_inline_result : ChosenInlineResult)`
- `handle(callback_query : CallbackQuery)`
- `handle(shipping_query : ShippingQuery)`
- `handle(pre_checkout_query : PreCheckoutQuery)`
- `handle(poll : Poll)`
- `handle(poll_answer : PollAnswer)`
- `handle_my_chat_member(my_chat_member : ChatMemberUpdated)`
- `handle(chat_member : ChatMemberUpdated)`
- `handle(chat_join_request : ChatJoinRequest)`
- `handle(message_reaction : MessageReactionUpdated)`
- `handle(message_reaction_count : MessageReactionCountUpdated)`
- `handle_business_connection(business_connection : BusinessConnection)`
- `handle_business_message(message : Message)`
- `handle_edited_business_message(message : Message)`
- `handle_deleted_business_messages(deleted_business_messages : BusinessMessagesDeleted)`
- `handle_guest_message(message : Message)`
- `handle(purchased_paid_media : PaidMediaPurchased)`
- `handle(chat_boost : ChatBoostUpdated)`
- `handle(removed_chat_boost : ChatBoostRemoved)`
- `handle(managed_bot : ManagedBotUpdated)`

### Implemented Types

- Message compatibility: `MessageId`, `InaccessibleMessage`,
  `MaybeInaccessibleMessage`, `ReplyParameters`, `TextQuote`,
  `ExternalReplyInfo`, `LinkPreviewOptions`, `Story`, `DirectMessagesTopic`,
  `MessageOrigin`, `MessageOriginUser`, `MessageOriginHiddenUser`,
  `MessageOriginChat`, `MessageOriginChannel`, `SuggestedPostInfo`,
  `SuggestedPostApproved`, `SuggestedPostApprovalFailed`,
  `SuggestedPostDeclined`, `SuggestedPostPaid`, `SuggestedPostRefunded`,
  `PaidMessagePriceChanged`, `DirectMessagePriceChanged`, `ChatOwnerLeft`,
  `ChatOwnerChanged`, `MessageAutoDeleteTimerChanged`, `SharedUser`,
  `UsersShared`, `ChatShared`, `WriteAccessAllowed`,
  `ProximityAlertTriggered`, `ChatBoostAdded`, `GiveawayCreated`,
  `Giveaway`, `GiveawayWinners`, `GiveawayCompleted`,
  `VideoChatScheduled`, `VideoChatStarted`, `VideoChatEnded`,
  `VideoChatParticipantsInvited`, `BackgroundFill`, `BackgroundType`,
  `ChatBackground`
- Chat profile objects: `Chat`, `ChatFullInfo`, `Birthdate`, `ChatLocation`,
  `UserRating`
- Input media: `InputMedia`, `InputMediaAnimation`, `InputMediaAudio`,
  `InputMediaDocument`, `InputMediaLivePhoto`, `InputMediaLocation`,
  `InputMediaPhoto`, `InputMediaSticker`, `InputMediaVenue`,
  `InputMediaVideo`
- Polls, reactions, and forum service messages: `Dice`, `Poll`,
  `PollOption`, `InputPollOption`, `PollMedia`, `PollAnswer`,
  `PollOptionAdded`, `PollOptionDeleted`, `ReactionTypeEmoji`,
  `ReactionTypeCustomEmoji`, `ReactionTypePaid`, `MessageReactionUpdated`,
  `MessageReactionCountUpdated`, `ReactionCount`, `ForumTopic`,
  `ForumTopicCreated`, `ForumTopicEdited`, `ForumTopicClosed`,
  `ForumTopicReopened`, `GeneralForumTopicHidden`,
  `GeneralForumTopicUnhidden`
- Chat administration: `ChatPermissions`, `ChatMember`,
  `ChatMemberUpdated`, `ChatInviteLink`, `ChatJoinRequest`
- Stars and paid media: `LivePhoto`, `PaidMediaInfo`, `PaidMedia`,
  `PaidMediaPreview`, `PaidMediaPhoto`, `PaidMediaVideo`,
  `PaidMediaLivePhoto`, `InputPaidMediaPhoto`, `InputPaidMediaVideo`,
  `InputPaidMediaLivePhoto`, `RefundedPayment`, `StarAmount`,
  `RevenueWithdrawalState`, `AffiliateInfo`, `TransactionPartner`,
  `StarTransaction`, `StarTransactions`, `PassportData`, `PassportFile`,
  `EncryptedPassportElement`, `EncryptedCredentials`, `PassportElementError`
- Gifts and stories: `Gift`, `Gifts`, `GiftInfo`, `GiftBackground`, `UniqueGift`,
  `UniqueGiftInfo`, `UniqueGiftModel`, `UniqueGiftSymbol`,
  `UniqueGiftBackdrop`, `UniqueGiftBackdropColors`, `UniqueGiftColors`,
  `OwnedGift`, `OwnedGiftRegular`, `OwnedGiftUnique`, `OwnedGifts`,
  `InputStoryContent`,
  `InputStoryContentPhoto`, `InputStoryContentVideo`, `StoryArea`,
  `StoryAreaPosition`, `StoryAreaType`, `StoryAreaTypeLocation`,
  `StoryAreaTypeSuggestedReaction`, `StoryAreaTypeLink`,
  `StoryAreaTypeWeather`, `StoryAreaTypeUniqueGift`, `LocationAddress`
- Stickers: `Sticker`, `StickerSet`, `InputSticker`, `MaskPosition`
- Keyboards and Web Apps: `InlineKeyboardButton`, `InlineKeyboardMarkup`,
  `KeyboardButton`, `ReplyKeyboardMarkup`, `LoginUrl`, `WebAppInfo`,
  `WebAppData`, `SwitchInlineQueryChosenChat`, `CopyTextButton`,
  `KeyboardButtonRequestUsers`, `KeyboardButtonRequestChat`,
  `KeyboardButtonRequestManagedBot`, `KeyboardButtonPollType`,
  `ChatAdministratorRights`, `SentWebAppMessage`, `PreparedInlineMessage`,
  `PreparedKeyboardButton`
- Webhook, command scope, and bot profile: `WebhookInfo`,
  `BotCommandScopeDefault`, `BotCommandScopeAllPrivateChats`,
  `BotCommandScopeAllGroupChats`, `BotCommandScopeAllChatAdministrators`,
  `BotCommandScopeChat`, `BotCommandScopeChatAdministrators`,
  `BotCommandScopeChatMember`, `BotName`, `BotDescription`,
  `BotShortDescription`
- Selected business and managed bot update containers:
  `BusinessConnection`, `BusinessMessagesDeleted`, `PaidMediaPurchased`,
  `ChatBoostUpdated`, `ChatBoostRemoved`, `ManagedBotUpdated`
- Business, guest, and managed bot support: `BusinessBotRights`,
  `BusinessIntro`, `BusinessLocation`, `BusinessOpeningHours`,
  `BusinessOpeningHoursInterval`, `InputProfilePhoto`, `SentGuestMessage`,
  `ManagedBotCreated`, `BotAccessSettings`

### Not implemented yet

- Webhook secret-token validation in `serve`
- Profile photo and chat menu button methods
- Newer chat administration APIs outside Phase 7, such as `set_chat_member_tag`
  and user profile audio methods
- Business-account owned gift management methods beyond gift settings
- Full business, guest, and managed bot method/type support

## Compatibility notes

Request parameters that are arrays or `JSON::Serializable` objects are
JSON-serialized before they are sent to Telegram. This includes inline query
results, command arrays, media arrays, reply markup, `ReplyParameters`, and
`LinkPreviewOptions`.

Some update types are parsed and dispatched before all related Bot API
methods are implemented. For example, `chat_join_request` updates can be
handled, but `approve_chat_join_request` is not available yet.

## Contributing

__Contributing is very welcomed!__

1. Fork it ( https://github.com/crystal-garage/telegram_bot/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [hangyas](https://github.com/hangyas) Krisztián Ádám - creator, maintainer
- [mamantoha](https://github.com/mamantoha) Anton Maminov - maintainer
