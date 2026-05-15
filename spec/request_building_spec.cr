require "./spec_helper"

class RequestBuildingBot < TelegramBot::Bot
  getter last_method, last_force_http, last_params, handled_update

  TRUE_METHODS = [
    "answerInlineQuery",
    "answerShippingQuery",
    "answerPreCheckoutQuery",
    "pinChatMessage",
    "unpinChatMessage",
    "sendMessageDraft",
    "setMyCommands",
    "deleteMyCommands",
    "setMyName",
    "setMyDescription",
    "setMyShortDescription",
    "setMyDefaultAdministratorRights",
    "deleteWebhook",
    "restrictChatMember",
    "approveChatJoinRequest",
    "declineChatJoinRequest",
    "setMessageReaction",
    "deleteMessageReaction",
    "deleteAllMessageReactions",
    "editForumTopic",
    "closeForumTopic",
    "reopenForumTopic",
    "deleteForumTopic",
    "unpinAllForumTopicMessages",
    "editGeneralForumTopic",
    "closeGeneralForumTopic",
    "reopenGeneralForumTopic",
    "hideGeneralForumTopic",
    "unhideGeneralForumTopic",
    "unpinAllGeneralForumTopicMessages",
  ]

  METHOD_RESPONSES = {
    "getMyCommands"                    => %([{"command":"start","description":"Start"}]),
    "getMyName"                        => %({"name":"Test Bot"}),
    "getMyDescription"                 => %({"description":"Long description"}),
    "getMyShortDescription"            => %({"short_description":"Short description"}),
    "getMyDefaultAdministratorRights"  => %({"can_delete_messages":true}),
    "getWebhookInfo"                   => %({"url":"https://example.com/hook","has_custom_certificate":false,"pending_update_count":3,"ip_address":"127.0.0.1","max_connections":40,"allowed_updates":["message"]}),
    "answerWebAppQuery"                => %({"inline_message_id":"inline-id"}),
    "savePreparedInlineMessage"        => %({"id":"prepared-inline-id","expiration_date":1800000000}),
    "savePreparedKeyboardButton"       => %({"id":"prepared-keyboard-id"}),
    "copyMessage"                      => %({"message_id":100}),
    "copyMessages"                     => %([{"message_id":100},{"message_id":101}]),
    "forwardMessages"                  => %([{"message_id":100},{"message_id":101}]),
    "createChatInviteLink"             => %({"invite_link":"https://t.me/+invite","creator":{"id":1,"is_bot":true,"first_name":"Bot"},"creates_join_request":true,"is_primary":false,"is_revoked":false,"name":"Invite"}),
    "editChatInviteLink"               => %({"invite_link":"https://t.me/+invite","creator":{"id":1,"is_bot":true,"first_name":"Bot"},"creates_join_request":false,"is_primary":false,"is_revoked":false,"name":"Edited"}),
    "createChatSubscriptionInviteLink" => %({"invite_link":"https://t.me/+sub","creator":{"id":1,"is_bot":true,"first_name":"Bot"},"creates_join_request":false,"is_primary":false,"is_revoked":false,"subscription_period":2592000,"subscription_price":100}),
    "editChatSubscriptionInviteLink"   => %({"invite_link":"https://t.me/+sub","creator":{"id":1,"is_bot":true,"first_name":"Bot"},"creates_join_request":false,"is_primary":false,"is_revoked":false,"name":"Sub"}),
    "revokeChatInviteLink"             => %({"invite_link":"https://t.me/+invite","creator":{"id":1,"is_bot":true,"first_name":"Bot"},"creates_join_request":false,"is_primary":false,"is_revoked":true}),
    "getForumTopicIconStickers"        => %([{"file_id":"sticker-id","width":512,"height":512}]),
    "createForumTopic"                 => %({"message_thread_id":42,"name":"Topic","icon_color":7322096,"icon_custom_emoji_id":"emoji-id"}),
  }

  def initialize
    super "testbot", "token"
    @last_method = nil.as(String?)
    @last_force_http = nil.as(Bool?)
    @last_params = {} of String => String?
    @handled_update = nil.as(String?)
  end

  protected def request(method : String, force_http : Bool = false, params = nil)
    @last_method = method
    @last_force_http = force_http
    @last_params = {} of String => String?

    params.try &.each do |key, value|
      @last_params[key] = value.nil? ? nil : value.to_s
    end

    if TRUE_METHODS.includes?(method)
      JSON.parse("true")
    elsif response = METHOD_RESPONSES[method]?
      JSON.parse(response)
    else
      JSON.parse(%({"message_id":1,"date":0,"chat":{"id":1,"type":"private"}}))
    end
  end

  def serialize_for_spec(params : Hash)
    serialize_params(params)
  end

  def param(name : String) : String
    if value = last_params[name]?
      value
    else
      fail "expected #{name} param"
    end
  end

  def handle(shipping_query : TelegramBot::ShippingQuery)
    @handled_update = shipping_query.id
  end

  def handle(pre_checkout_query : TelegramBot::PreCheckoutQuery)
    @handled_update = pre_checkout_query.id
  end

  def handle_business_connection(business_connection : TelegramBot::BusinessConnection)
    @handled_update = business_connection.id
  end

  def handle_business_message(message : TelegramBot::Message)
    @handled_update = "business_message:#{message.message_id}"
  end

  def handle_edited_business_message(message : TelegramBot::Message)
    @handled_update = "edited_business_message:#{message.message_id}"
  end

  def handle_deleted_business_messages(deleted_business_messages : TelegramBot::BusinessMessagesDeleted)
    @handled_update = deleted_business_messages.business_connection_id
  end

  def handle_guest_message(message : TelegramBot::Message)
    @handled_update = "guest_message:#{message.message_id}"
  end

  def handle(message_reaction : TelegramBot::MessageReactionUpdated)
    @handled_update = "message_reaction:#{message_reaction.message_id}"
  end

  def handle(message_reaction_count : TelegramBot::MessageReactionCountUpdated)
    @handled_update = "message_reaction_count:#{message_reaction_count.message_id}"
  end

  def handle(purchased_paid_media : TelegramBot::PaidMediaPurchased)
    @handled_update = purchased_paid_media.paid_media_payload
  end

  def handle(poll : TelegramBot::Poll)
    @handled_update = poll.id
  end

  def handle(poll_answer : TelegramBot::PollAnswer)
    @handled_update = poll_answer.poll_id
  end

  def handle_my_chat_member(my_chat_member : TelegramBot::ChatMemberUpdated)
    @handled_update = "my_chat_member:#{my_chat_member.date}"
  end

  def handle(chat_member : TelegramBot::ChatMemberUpdated)
    @handled_update = "chat_member:#{chat_member.date}"
  end

  def handle(chat_join_request : TelegramBot::ChatJoinRequest)
    @handled_update = "chat_join_request:#{chat_join_request.user_chat_id}"
  end

  def handle(chat_boost : TelegramBot::ChatBoostUpdated)
    @handled_update = chat_boost.boost.try(&.boost_id)
  end

  def handle(removed_chat_boost : TelegramBot::ChatBoostRemoved)
    @handled_update = removed_chat_boost.boost_id
  end

  def handle(managed_bot : TelegramBot::ManagedBotUpdated)
    @handled_update = managed_bot.bot.try(&.username)
  end
end

describe TelegramBot::Bot do
  it "builds sendPhoto with caption" do
    bot = RequestBuildingBot.new
    bot.send_photo(123, "photo-id", caption: "caption")

    bot.last_method.should eq("sendPhoto")
    bot.last_params["photo"].should eq("photo-id")
    bot.last_params["caption"].should eq("caption")
  end

  it "builds sendMessage with modern shared params" do
    bot = RequestBuildingBot.new
    reply_parameters = TelegramBot::ReplyParameters.new(42)
    suggested_post_parameters = TelegramBot::SuggestedPostParameters.new(
      price: TelegramBot::SuggestedPostPrice.new("XTR", 100_i64),
      send_date: 1_800_000_000
    )

    bot.send_message(
      123,
      "hello",
      entities: [TelegramBot::MessageEntity.new("bold", 0, 5)],
      link_preview_options: TelegramBot::LinkPreviewOptions.new(is_disabled: true),
      protect_content: true,
      reply_parameters: reply_parameters,
      message_effect_id: "effect-id",
      allow_paid_broadcast: true,
      suggested_post_parameters: suggested_post_parameters,
      business_connection_id: "business-id",
      message_thread_id: 10,
      direct_messages_topic_id: 20_i64
    )

    bot.last_method.should eq("sendMessage")
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["message_thread_id"].should eq("10")
    bot.last_params["direct_messages_topic_id"].should eq("20")
    bot.param("entities").should contain("MessageEntity")
    bot.param("link_preview_options").should contain("LinkPreviewOptions")
    bot.last_params["protect_content"].should eq("true")
    bot.param("reply_parameters").should contain("ReplyParameters")
    bot.last_params["message_effect_id"].should eq("effect-id")
    bot.last_params["allow_paid_broadcast"].should eq("true")
    bot.param("suggested_post_parameters").should contain("SuggestedPostParameters")
  end

  it "builds sendAudio with the correct method" do
    bot = RequestBuildingBot.new
    bot.send_audio(123, "audio-id", duration: 10, performer: "performer", title: "title")

    bot.last_method.should eq("sendAudio")
    bot.last_params["audio"].should eq("audio-id")
    bot.last_params["duration"].should eq("10")
    bot.last_params["performer"].should eq("performer")
    bot.last_params["title"].should eq("title")
  end

  it "builds sendVideoNote with video_note" do
    bot = RequestBuildingBot.new
    bot.send_video_note(123, "video-note-id", duration: 10, length: 240)

    bot.last_method.should eq("sendVideoNote")
    bot.last_params["video_note"].should eq("video-note-id")
    bot.last_params["duration"].should eq("10")
    bot.last_params["length"].should eq("240")
  end

  it "builds sendAnimation" do
    bot = RequestBuildingBot.new
    bot.send_animation(123, "animation-id", duration: 10, width: 320, height: 240, caption: "caption")

    bot.last_method.should eq("sendAnimation")
    bot.last_params["animation"].should eq("animation-id")
    bot.last_params["duration"].should eq("10")
    bot.last_params["width"].should eq("320")
    bot.last_params["height"].should eq("240")
    bot.last_params["caption"].should eq("caption")
  end

  it "builds copy and forward batch methods" do
    bot = RequestBuildingBot.new

    copied = bot.copy_message(123, 456, 7, caption: "copy", protect_content: true)
    copied_messages = bot.copy_messages(123, 456, [7, 8], remove_caption: true)
    forwarded_messages = bot.forward_messages(123, 456, [7, 8], protect_content: true)

    copied.try(&.message_id).should eq(100)
    copied_messages.map(&.message_id).should eq([100, 101])
    forwarded_messages.map(&.message_id).should eq([100, 101])
  end

  it "builds sendPoll and sendDice" do
    bot = RequestBuildingBot.new
    options = [
      TelegramBot::InputPollOption.new("A"),
      TelegramBot::InputPollOption.new("B"),
    ]

    bot.send_poll(123, "Question?", options, allows_multiple_answers: true, country_codes: ["US"])

    bot.last_method.should eq("sendPoll")
    bot.last_params["question"].should eq("Question?")
    bot.param("options").should contain("InputPollOption")
    bot.last_params["allows_multiple_answers"].should eq("true")
    bot.last_params["country_codes"].should eq("[\"US\"]")

    bot.send_dice(123, "🎲", protect_content: true)

    bot.last_method.should eq("sendDice")
    bot.last_params["emoji"].should eq("🎲")
    bot.last_params["protect_content"].should eq("true")
  end

  it "builds sendMessageDraft" do
    bot = RequestBuildingBot.new

    bot.send_message_draft(123, 99, text: "draft", entities: [TelegramBot::MessageEntity.new("bold", 0, 5)])

    bot.last_method.should eq("sendMessageDraft")
    bot.last_force_http.should be_true
    bot.last_params["chat_id"].should eq("123")
    bot.last_params["draft_id"].should eq("99")
    bot.last_params["text"].should eq("draft")
    bot.param("entities").should contain("MessageEntity")
  end

  it "builds sendInvoice with title" do
    bot = RequestBuildingBot.new
    bot.send_invoice(
      chat_id: 123,
      title: "invoice title",
      description: "description",
      payload: "payload",
      provider_token: "provider-token",
      start_parameter: "start",
      currency: "USD",
      prices: [] of TelegramBot::LabeledPrice
    )

    bot.last_method.should eq("sendInvoice")
    bot.last_params["title"].should eq("invoice title")
    bot.last_params.has_key?("tilte").should be_false
  end

  it "builds sendContact with disable_notification" do
    bot = RequestBuildingBot.new
    bot.send_contact(123, "+15550100", "First", disable_notification: true)

    bot.last_method.should eq("sendContact")
    bot.last_params["disable_notification"].should eq("true")
  end

  it "builds answerShippingQuery with shipping_options" do
    bot = RequestBuildingBot.new
    bot.answer_shipping_query("query-id", true, [] of TelegramBot::ShippingOption)

    bot.last_method.should eq("answerShippingQuery")
    bot.last_params["shipping_query_id"].should eq("query-id")
    bot.last_params["shipping_options"].should eq("[]")
    bot.last_params.has_key?("shipping_option").should be_false
  end

  it "serializes arrays and skips nil request params" do
    bot = RequestBuildingBot.new
    params = bot.serialize_for_spec({
      "allowed_updates" => ["message", "callback_query"],
      "timeout"         => nil,
    })

    params["allowed_updates"].should eq(%(["message","callback_query"]))
    params.has_key?("timeout").should be_false
  end

  it "serializes JSON objects consistently" do
    bot = RequestBuildingBot.new
    reply_markup = TelegramBot::InlineKeyboardMarkup.new([
      [TelegramBot::InlineKeyboardButton.new("Open", url: "https://example.com")],
    ])
    params = bot.serialize_for_spec({"reply_markup" => reply_markup})

    JSON.parse(params["reply_markup"].as(String)).should eq(JSON.parse(<<-JSON))
      {
        "inline_keyboard": [[{"text": "Open", "url": "https://example.com"}]]
      }
      JSON
  end

  it "serializes arrays of JSON objects" do
    bot = RequestBuildingBot.new
    commands = [
      TelegramBot::BotCommand.new("start", "Start the bot"),
      TelegramBot::BotCommand.new("help", "Show help"),
    ]
    params = bot.serialize_for_spec({"commands" => commands})

    JSON.parse(params["commands"].as(String)).should eq(JSON.parse(<<-JSON))
      [
        {"command": "start", "description": "Start the bot"},
        {"command": "help", "description": "Show help"}
      ]
      JSON
  end

  it "serializes inline query results through their base type" do
    bot = RequestBuildingBot.new
    content = TelegramBot::InputTextMessageContent.new("Article details")
    results = [TelegramBot::InlineQueryResultArticle.new("article/1", "Article", content)] of TelegramBot::InlineQueryResult
    params = bot.serialize_for_spec({"results" => results})

    JSON.parse(params["results"].as(String)).should eq(JSON.parse(<<-JSON))
      [
        {
          "type": "article",
          "id": "article/1",
          "title": "Article",
          "input_message_content": {"message_text": "Article details"}
        }
      ]
      JSON
  end

  it "keeps wrappers passing native arrays to the request layer" do
    bot = RequestBuildingBot.new
    content = TelegramBot::InputTextMessageContent.new("Article details")
    results = [TelegramBot::InlineQueryResultArticle.new("article/1", "Article", content)] of TelegramBot::InlineQueryResult

    bot.answer_inline_query("inline-query-id", results)

    bot.last_method.should eq("answerInlineQuery")
    if results_param = bot.last_params["results"]?
      results_param.should contain("InlineQueryResultArticle")
    else
      fail "expected results param"
    end
  end

  it "serializes modern inline keyboard button fields" do
    bot = RequestBuildingBot.new
    markup = TelegramBot::InlineKeyboardMarkup.new([
      [
        TelegramBot::InlineKeyboardButton.new(
          "Open",
          icon_custom_emoji_id: "emoji-id",
          style: "primary",
          web_app: TelegramBot::WebAppInfo.new("https://example.com/app"),
          login_url: TelegramBot::LoginUrl.new("https://example.com/login", request_write_access: true),
          switch_inline_query_current_chat: "search",
          switch_inline_query_chosen_chat: TelegramBot::SwitchInlineQueryChosenChat.new(
            query: "chosen",
            allow_user_chats: true
          ),
          copy_text: TelegramBot::CopyTextButton.new("copy me"),
          pay: true
        ),
      ],
    ])
    params = bot.serialize_for_spec({"reply_markup" => markup})

    JSON.parse(params["reply_markup"].as(String)).should eq(JSON.parse(<<-JSON))
      {
        "inline_keyboard": [[{
          "text": "Open",
          "icon_custom_emoji_id": "emoji-id",
          "style": "primary",
          "web_app": {"url": "https://example.com/app"},
          "login_url": {"url": "https://example.com/login", "request_write_access": true},
          "switch_inline_query_current_chat": "search",
          "switch_inline_query_chosen_chat": {"query": "chosen", "allow_user_chats": true},
          "copy_text": {"text": "copy me"},
          "pay": true
        }]]
      }
      JSON
  end

  it "serializes modern reply keyboard button fields" do
    bot = RequestBuildingBot.new
    markup = TelegramBot::ReplyKeyboardMarkup.new([
      [
        TelegramBot::KeyboardButton.new(
          "Share",
          icon_custom_emoji_id: "emoji-id",
          style: "success",
          request_users: TelegramBot::KeyboardButtonRequestUsers.new(
            1,
            user_is_bot: false,
            max_quantity: 2,
            request_username: true
          ),
          request_chat: TelegramBot::KeyboardButtonRequestChat.new(
            2,
            false,
            bot_administrator_rights: TelegramBot::ChatAdministratorRights.new(can_invite_users: true),
            request_title: true
          ),
          request_managed_bot: TelegramBot::KeyboardButtonRequestManagedBot.new(
            3,
            suggested_username: "managed_bot"
          ),
          request_poll: TelegramBot::KeyboardButtonPollType.new("quiz"),
          web_app: TelegramBot::WebAppInfo.new("https://example.com/reply-app")
        ),
      ],
    ])
    params = bot.serialize_for_spec({"reply_markup" => markup})

    JSON.parse(params["reply_markup"].as(String)).should eq(JSON.parse(<<-JSON))
      {
        "keyboard": [[{
          "text": "Share",
          "icon_custom_emoji_id": "emoji-id",
          "style": "success",
          "request_users": {
            "request_id": 1,
            "user_is_bot": false,
            "max_quantity": 2,
            "request_username": true
          },
          "request_chat": {
            "request_id": 2,
            "chat_is_channel": false,
            "bot_administrator_rights": {"can_invite_users": true},
            "request_title": true
          },
          "request_managed_bot": {
            "request_id": 3,
            "suggested_username": "managed_bot"
          },
          "request_poll": {"type": "quiz"},
          "web_app": {"url": "https://example.com/reply-app"}
        }]]
      }
      JSON
  end

  it "builds Web App and prepared message methods" do
    bot = RequestBuildingBot.new
    content = TelegramBot::InputTextMessageContent.new("Web App result")
    result = TelegramBot::InlineQueryResultArticle.new("article/1", "Article", content)

    sent = bot.answer_web_app_query("web-app-query-id", result)

    sent.inline_message_id.should eq("inline-id")
    bot.last_method.should eq("answerWebAppQuery")
    bot.last_params["web_app_query_id"].should eq("web-app-query-id")
    bot.param("result").should contain("InlineQueryResultArticle")

    prepared_inline = bot.save_prepared_inline_message(1, result, allow_user_chats: true)

    prepared_inline.id.should eq("prepared-inline-id")
    prepared_inline.expiration_date.should eq(1_800_000_000)
    bot.last_method.should eq("savePreparedInlineMessage")
    bot.last_params["allow_user_chats"].should eq("true")

    prepared_button = bot.save_prepared_keyboard_button(
      1,
      TelegramBot::KeyboardButton.new("Share user", request_users: TelegramBot::KeyboardButtonRequestUsers.new(1))
    )

    prepared_button.id.should eq("prepared-keyboard-id")
    bot.last_method.should eq("savePreparedKeyboardButton")
    bot.param("button").should contain("KeyboardButton")
  end

  it "serializes bot command scopes" do
    bot = RequestBuildingBot.new
    commands = [TelegramBot::BotCommand.new("start", "Start")]
    scope = TelegramBot::BotCommandScopeChatMember.new("@group", 123)

    bot.set_my_commands(commands, scope: scope, language_code: "en")

    bot.last_method.should eq("setMyCommands")
    bot.param("commands").should contain("BotCommand")
    bot.param("scope").should contain("BotCommandScopeChatMember")
    bot.last_params["language_code"].should eq("en")

    params = bot.serialize_for_spec({"scope" => scope})
    JSON.parse(params["scope"].as(String)).should eq(JSON.parse(<<-JSON))
      {
        "type": "chat_member",
        "chat_id": "@group",
        "user_id": 123
      }
      JSON
  end

  it "builds bot command metadata methods" do
    bot = RequestBuildingBot.new
    scope = TelegramBot::BotCommandScopeAllPrivateChats.new

    commands = bot.get_my_commands(scope: scope, language_code: "en")

    commands.first.command.should eq("start")
    bot.last_method.should eq("getMyCommands")
    bot.last_force_http.should be_true
    bot.param("scope").should contain("BotCommandScopeAllPrivateChats")
    bot.last_params["language_code"].should eq("en")

    deleted = bot.delete_my_commands(scope: scope)

    deleted.should be_true
    bot.last_method.should eq("deleteMyCommands")
    bot.last_force_http.should be_true
  end

  it "builds webhook metadata methods" do
    bot = RequestBuildingBot.new

    deleted = bot.delete_webhook(drop_pending_updates: true)

    deleted.should be_true
    bot.last_method.should eq("deleteWebhook")
    bot.last_force_http.should be_true
    bot.last_params["drop_pending_updates"].should eq("true")

    info = bot.get_webhook_info

    info.url.should eq("https://example.com/hook")
    info.has_custom_certificate?.should be_false
    info.pending_update_count.should eq(3)
    info.ip_address.should eq("127.0.0.1")
    info.allowed_updates.should eq(["message"])
    bot.last_method.should eq("getWebhookInfo")
    bot.last_force_http.should be_true
  end

  it "builds bot profile and default administrator rights methods" do
    bot = RequestBuildingBot.new

    bot.set_my_name("Test Bot", language_code: "en").should be_true
    bot.last_method.should eq("setMyName")
    bot.last_force_http.should be_true
    bot.last_params["name"].should eq("Test Bot")
    bot.last_params["language_code"].should eq("en")

    bot.get_my_name(language_code: "en").name.should eq("Test Bot")
    bot.last_method.should eq("getMyName")
    bot.last_params["language_code"].should eq("en")

    bot.set_my_description("Long description").should be_true
    bot.last_method.should eq("setMyDescription")
    bot.get_my_description.description.should eq("Long description")

    bot.set_my_short_description("Short description").should be_true
    bot.last_method.should eq("setMyShortDescription")
    bot.get_my_short_description.short_description.should eq("Short description")

    rights = TelegramBot::ChatAdministratorRights.new(can_delete_messages: true)
    bot.set_my_default_administrator_rights(rights, for_channels: true).should be_true
    bot.last_method.should eq("setMyDefaultAdministratorRights")
    bot.param("rights").should contain("ChatAdministratorRights")
    bot.last_params["for_channels"].should eq("true")

    bot.get_my_default_administrator_rights(for_channels: true).can_delete_messages?.should be_true
    bot.last_method.should eq("getMyDefaultAdministratorRights")
    bot.last_force_http.should be_true
  end

  it "builds chat permissions, join request, and invite link methods" do
    bot = RequestBuildingBot.new
    permissions = TelegramBot::ChatPermissions.new(
      can_send_messages: true,
      can_send_photos: true,
      can_react_to_messages: true
    )

    bot.restrict_chat_member("@group", 123, permissions: permissions, use_independent_chat_permissions: true)

    bot.last_method.should eq("restrictChatMember")
    bot.param("permissions").should contain("ChatPermissions")
    bot.last_params["use_independent_chat_permissions"].should eq("true")

    bot.restrict_chat_member("@group", 123, can_send_media_messages: true)
    bot.param("permissions").should contain("can_send_photos")

    invite = bot.create_chat_invite_link("@group", name: "Invite", creates_join_request: true)

    invite.try(&.invite_link).should eq("https://t.me/+invite")
    invite.try(&.creates_join_request?).should be_true
    bot.last_method.should eq("createChatInviteLink")
    bot.last_params["name"].should eq("Invite")

    edited = bot.edit_chat_invite_link("@group", "https://t.me/+invite", name: "Edited")
    edited.try(&.name).should eq("Edited")
    bot.last_method.should eq("editChatInviteLink")

    subscription = bot.create_chat_subscription_invite_link("@channel", 2_592_000, 100, name: "Sub")
    subscription.try(&.subscription_price).should eq(100)
    bot.last_method.should eq("createChatSubscriptionInviteLink")

    revoked = bot.revoke_chat_invite_link("@group", "https://t.me/+invite")
    revoked.try(&.is_revoked?).should be_true
    bot.last_method.should eq("revokeChatInviteLink")

    bot.approve_chat_join_request("@group", 123).should be_true
    bot.last_method.should eq("approveChatJoinRequest")
    bot.decline_chat_join_request("@group", 123).should be_true
    bot.last_method.should eq("declineChatJoinRequest")

    JSON.parse(permissions.to_json).should eq(JSON.parse(<<-JSON))
      {
        "can_send_messages": true,
        "can_send_photos": true,
        "can_react_to_messages": true
      }
      JSON
  end

  it "builds forum topic and reaction methods" do
    bot = RequestBuildingBot.new
    reaction = TelegramBot::ReactionTypeEmoji.new("👍")

    bot.set_message_reaction("@group", 10, [reaction] of TelegramBot::ReactionType, is_big: true).should be_true
    bot.last_method.should eq("setMessageReaction")
    bot.param("reaction").should contain("ReactionTypeEmoji")
    bot.last_params["is_big"].should eq("true")

    bot.delete_message_reaction("@group", 10, reaction).should be_true
    bot.last_method.should eq("deleteMessageReaction")
    bot.param("reaction").should contain("ReactionTypeEmoji")

    bot.delete_all_message_reactions("@group", 10).should be_true
    bot.last_method.should eq("deleteAllMessageReactions")

    stickers = bot.get_forum_topic_icon_stickers
    stickers.first.file_id.should eq("sticker-id")
    bot.last_method.should eq("getForumTopicIconStickers")
    bot.last_force_http.should be_true

    topic = bot.create_forum_topic("@group", "Topic", icon_color: 7_322_096, icon_custom_emoji_id: "emoji-id")
    topic.try(&.message_thread_id).should eq(42)
    bot.last_method.should eq("createForumTopic")

    bot.edit_forum_topic("@group", 42, name: "New Topic").should be_true
    bot.last_method.should eq("editForumTopic")
    bot.close_forum_topic("@group", 42).should be_true
    bot.last_method.should eq("closeForumTopic")
    bot.reopen_forum_topic("@group", 42).should be_true
    bot.last_method.should eq("reopenForumTopic")
    bot.delete_forum_topic("@group", 42).should be_true
    bot.last_method.should eq("deleteForumTopic")
    bot.unpin_all_forum_topic_messages("@group", 42).should be_true
    bot.last_method.should eq("unpinAllForumTopicMessages")

    bot.edit_general_forum_topic("@group", "General").should be_true
    bot.last_method.should eq("editGeneralForumTopic")
    bot.close_general_forum_topic("@group").should be_true
    bot.last_method.should eq("closeGeneralForumTopic")
    bot.reopen_general_forum_topic("@group").should be_true
    bot.last_method.should eq("reopenGeneralForumTopic")
    bot.hide_general_forum_topic("@group").should be_true
    bot.last_method.should eq("hideGeneralForumTopic")
    bot.unhide_general_forum_topic("@group").should be_true
    bot.last_method.should eq("unhideGeneralForumTopic")
    bot.unpin_all_general_forum_topic_messages("@group").should be_true
    bot.last_method.should eq("unpinAllGeneralForumTopicMessages")
  end

  it "builds multipart bodies with serialized non-file params" do
    body = HTTP::Client::MultipartBody.new({"allowed_updates" => %(["message"])})

    body.content_type.should contain("multipart/form-data")
    body.bodyg.should contain(%(["message"]))
  end

  it "builds multipart file parts without manual header assembly" do
    body = HTTP::Client::MultipartBody.new
    body.add_file("document", "binary\u0000content", filename: "file.bin")
    payload = body.bodyg

    payload.should contain(%(name="document"; filename="file.bin"))
    payload.should contain("binary\u0000content")
  end

  it "dispatches shipping queries" do
    bot = RequestBuildingBot.new
    update = TelegramBot::Update.from_json(<<-JSON)
      {
        "update_id": 1,
        "shipping_query": {
          "id": "shipping-id",
          "from": {"id": 1, "is_bot": false, "first_name": "User"},
          "invoice_payload": "payload",
          "shipping_address": {
            "country_code": "US",
            "state": "CA",
            "city": "San Francisco",
            "street_line1": "Market",
            "street_line2": "",
            "post_code": "94103"
          }
        }
      }
      JSON

    bot.handle_update(update)

    bot.handled_update.should eq("shipping-id")
  end

  it "dispatches pre-checkout queries" do
    bot = RequestBuildingBot.new
    update = TelegramBot::Update.from_json(<<-JSON)
      {
        "update_id": 1,
        "pre_checkout_query": {
          "id": "pre-checkout-id",
          "from": {"id": 1, "is_bot": false, "first_name": "User"},
          "currency": "USD",
          "total_amount": 1000,
          "invoice_payload": "payload"
        }
      }
      JSON

    bot.handle_update(update)

    bot.handled_update.should eq("pre-checkout-id")
  end

  it "dispatches modern update fields" do
    cases = {
      {
        <<-JSON,
          {
            "update_id": 1,
            "business_connection": {"id": "business-connection-id"}
          }
          JSON
        "business-connection-id",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "business_message": {"message_id": 10, "date": 0, "chat": {"id": 1, "type": "private"}}
          }
          JSON
        "business_message:10",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "edited_business_message": {"message_id": 11, "date": 0, "chat": {"id": 1, "type": "private"}}
          }
          JSON
        "edited_business_message:11",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "deleted_business_messages": {
              "business_connection_id": "deleted-business-id",
              "chat": {"id": 1, "type": "private"},
              "message_ids": [1, 2]
            }
          }
          JSON
        "deleted-business-id",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "guest_message": {"message_id": 12, "date": 0, "chat": {"id": 1, "type": "private"}}
          }
          JSON
        "guest_message:12",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "message_reaction": {
              "chat": {"id": 1, "type": "private"},
              "message_id": 13,
              "date": 0,
              "old_reaction": [],
              "new_reaction": []
            }
          }
          JSON
        "message_reaction:13",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "message_reaction_count": {
              "chat": {"id": 1, "type": "private"},
              "message_id": 14,
              "date": 0,
              "reactions": []
            }
          }
          JSON
        "message_reaction_count:14",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "purchased_paid_media": {
              "from": {"id": 1, "is_bot": false, "first_name": "User"},
              "paid_media_payload": "paid-media-payload"
            }
          }
          JSON
        "paid-media-payload",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "poll": {
              "id": "poll-id",
              "question": "Question?",
              "options": [],
              "total_voter_count": 0,
              "is_closed": false,
              "is_anonymous": false,
              "type": "regular",
              "allows_multiple_answers": false
            }
          }
          JSON
        "poll-id",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "poll_answer": {
              "poll_id": "poll-answer-id",
              "user": {"id": 1, "is_bot": false, "first_name": "User"},
              "option_ids": [0]
            }
          }
          JSON
        "poll-answer-id",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "my_chat_member": {
              "chat": {"id": 1, "type": "private"},
              "from": {"id": 1, "is_bot": false, "first_name": "User"},
              "date": 15,
              "old_chat_member": {"user": {"id": 2, "is_bot": true, "first_name": "Bot"}, "status": "member"},
              "new_chat_member": {"user": {"id": 2, "is_bot": true, "first_name": "Bot"}, "status": "administrator"}
            }
          }
          JSON
        "my_chat_member:15",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "chat_member": {
              "chat": {"id": 1, "type": "private"},
              "from": {"id": 1, "is_bot": false, "first_name": "User"},
              "date": 16,
              "old_chat_member": {"user": {"id": 3, "is_bot": false, "first_name": "Member"}, "status": "member"},
              "new_chat_member": {"user": {"id": 3, "is_bot": false, "first_name": "Member"}, "status": "left"}
            }
          }
          JSON
        "chat_member:16",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "chat_join_request": {
              "chat": {"id": 1, "type": "private"},
              "from": {"id": 1, "is_bot": false, "first_name": "User"},
              "user_chat_id": 12345,
              "date": 0
            }
          }
          JSON
        "chat_join_request:12345",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "chat_boost": {
              "chat": {"id": 1, "type": "private"},
              "boost": {
                "boost_id": "boost-id",
                "add_date": 0,
                "expiration_date": 1,
                "source": {"source": "premium", "user": {"id": 1, "is_bot": false, "first_name": "User"}}
              }
            }
          }
          JSON
        "boost-id",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "removed_chat_boost": {
              "chat": {"id": 1, "type": "private"},
              "boost_id": "removed-boost-id",
              "remove_date": 0,
              "source": {"source": "premium", "user": {"id": 1, "is_bot": false, "first_name": "User"}}
            }
          }
          JSON
        "removed-boost-id",
      },
      {
        <<-JSON,
          {
            "update_id": 1,
            "managed_bot": {
              "bot": {"id": 2, "is_bot": true, "first_name": "Managed", "username": "managed_bot"}
            }
          }
          JSON
        "managed_bot",
      },
    }

    cases.each do |json, expected|
      bot = RequestBuildingBot.new
      bot.handle_update(TelegramBot::Update.from_json(json))
      bot.handled_update.should eq(expected)
    end
  end
end
