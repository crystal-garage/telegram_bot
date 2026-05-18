require "./spec_helper"

class RequestBuildingBot < TelegramBot::Bot
  getter last_method, last_force_http, last_params, handled_update

  TRUE_METHODS = [
    "logOut",
    "close",
    "answerInlineQuery",
    "answerShippingQuery",
    "answerPreCheckoutQuery",
    "pinChatMessage",
    "unpinChatMessage",
    "sendMessageDraft",
    "deleteMessages",
    "approveSuggestedPost",
    "declineSuggestedPost",
    "setPassportDataErrors",
    "setMyCommands",
    "deleteMyCommands",
    "setMyName",
    "setMyDescription",
    "setMyShortDescription",
    "setMyProfilePhoto",
    "removeMyProfilePhoto",
    "setChatMenuButton",
    "verifyUser",
    "verifyChat",
    "removeUserVerification",
    "removeChatVerification",
    "setMyDefaultAdministratorRights",
    "deleteWebhook",
    "banChatMember",
    "banChatSenderChat",
    "unbanChatSenderChat",
    "restrictChatMember",
    "promoteChatMember",
    "setChatPermissions",
    "setChatAdministratorCustomTitle",
    "setChatMemberTag",
    "setUserEmojiStatus",
    "approveChatJoinRequest",
    "declineChatJoinRequest",
    "unpinAllChatMessages",
    "sendChatAction",
    "setMessageReaction",
    "deleteMessageReaction",
    "deleteAllMessageReactions",
    "refundStarPayment",
    "editUserStarSubscription",
    "sendGift",
    "giftPremiumSubscription",
    "transferBusinessAccountStars",
    "convertGiftToStars",
    "upgradeGift",
    "transferGift",
    "deleteStory",
    "readBusinessMessage",
    "deleteBusinessMessages",
    "setBusinessAccountName",
    "setBusinessAccountUsername",
    "setBusinessAccountBio",
    "setBusinessAccountProfilePhoto",
    "removeBusinessAccountProfilePhoto",
    "setBusinessAccountGiftSettings",
    "setManagedBotAccessSettings",
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
    "createNewStickerSet",
    "addStickerToSet",
    "replaceStickerInSet",
    "setStickerPositionInSet",
    "setStickerEmojiList",
    "setStickerKeywords",
    "setStickerMaskPosition",
    "setStickerSetTitle",
    "setStickerSetThumbnail",
    "setCustomEmojiStickerSetThumbnail",
    "deleteStickerFromSet",
    "deleteStickerSet",
  ]

  METHOD_RESPONSES = {
    "getMyCommands"                    => %([{"command":"start","description":"Start"}]),
    "getMyName"                        => %({"name":"Test Bot"}),
    "getMyDescription"                 => %({"description":"Long description"}),
    "getMyShortDescription"            => %({"short_description":"Short description"}),
    "getChatMenuButton"                => %({"type":"web_app","text":"Open","web_app":{"url":"https://example.com/app"}}),
    "getMyDefaultAdministratorRights"  => %({"is_anonymous":false,"can_manage_chat":false,"can_delete_messages":true,"can_manage_video_chats":false,"can_restrict_members":false,"can_promote_members":false,"can_change_info":false,"can_invite_users":false,"can_post_stories":false,"can_edit_stories":false,"can_delete_stories":false}),
    "getWebhookInfo"                   => %({"url":"https://example.com/hook","has_custom_certificate":false,"pending_update_count":3,"ip_address":"127.0.0.1","max_connections":40,"allowed_updates":["message"]}),
    "getChatAdministrators"            => %([{"status":"administrator","user":{"id":1,"is_bot":false,"first_name":"Admin"}}]),
    "getChatMemberCount"               => %(12),
    "getUserProfileAudios"             => %({"total_count":1,"audios":[{"file_id":"audio-id","file_unique_id":"audio-unique-id","duration":10}]}),
    "getUserChatBoosts"                => %({"boosts":[{"boost_id":"boost-id","add_date":1800000000,"expiration_date":1900000000,"source":{"source":"premium","user":{"id":1,"is_bot":false,"first_name":"User"}}}]}),
    "getUserPersonalChatMessages"      => %([{"message_id":1,"date":0,"chat":{"id":1,"type":"private"},"text":"Personal"}]),
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
    "getForumTopicIconStickers"        => %([{"file_id": "sticker-id", "file_unique_id": "sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false}]),
    "getStickerSet"                    => %({"name":"set_name","title":"Sticker Set","sticker_type":"regular","stickers":[{"file_id":"sticker-id","file_unique_id":"sticker-id-unique","type":"regular","width":512,"height":512,"is_animated":false,"is_video":false}]}),
    "getCustomEmojiStickers"           => %([{"file_id":"custom-emoji-id","file_unique_id":"custom-emoji-unique","type":"custom_emoji","width":512,"height":512,"is_animated":true,"is_video":false,"custom_emoji_id":"emoji-id"}]),
    "uploadStickerFile"                => %({"file_id":"uploaded-sticker-id","file_unique_id":"uploaded-sticker-unique-id"}),
    "createForumTopic"                 => %({"message_thread_id":42,"name":"Topic","icon_color":7322096,"icon_custom_emoji_id":"emoji-id"}),
    "sendPaidMedia"                    => %({"message_id":1,"date":0,"chat":{"id":1,"type":"private"},"paid_media":{"star_count":10,"paid_media":[{"type":"preview","width":320,"height":240}]}}),
    "getMyStarBalance"                 => %({"amount":100,"nanostar_amount":500}),
    "getStarTransactions"              => %({"transactions":[{"id":"tx-id","amount":10,"date":1800000000,"source":{"type":"user","transaction_type":"paid_media_payment","user":{"id":1,"is_bot":false,"first_name":"User"},"paid_media_payload":"payload","paid_media":[{"type":"preview","width":320}]}}]}),
    "getAvailableGifts"                => %({"gifts":[{"id":"gift-id","sticker":{"file_id": "sticker-id", "file_unique_id": "sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},"star_count":100,"upgrade_star_count":25}]}),
    "getBusinessAccountStarBalance"    => %({"amount":250,"nanostar_amount":0}),
    "getBusinessAccountGifts"          => %({"total_count":1,"gifts":[{"type":"regular","gift":{"id":"gift-id","sticker":{"file_id":"sticker-id","file_unique_id":"sticker-id-unique","type":"regular","width":512,"height":512,"is_animated":false,"is_video":false},"star_count":100},"owned_gift_id":"owned-gift-id","send_date":1800000000}],"next_offset":"next"}),
    "getUserGifts"                     => %({"total_count":1,"gifts":[{"type":"regular","gift":{"id":"gift-id","sticker":{"file_id":"sticker-id","file_unique_id":"sticker-id-unique","type":"regular","width":512,"height":512,"is_animated":false,"is_video":false},"star_count":100},"owned_gift_id":"owned-gift-id","send_date":1800000000}]}),
    "getChatGifts"                     => %({"total_count":1,"gifts":[{"type":"regular","gift":{"id":"gift-id","sticker":{"file_id":"sticker-id","file_unique_id":"sticker-id-unique","type":"regular","width":512,"height":512,"is_animated":false,"is_video":false},"star_count":100},"owned_gift_id":"owned-gift-id","send_date":1800000000}]}),
    "postStory"                        => %({"chat":{"id":1,"type":"private"},"id":10}),
    "repostStory"                      => %({"chat":{"id":1,"type":"private"},"id":11}),
    "editStory"                        => %({"chat":{"id":1,"type":"private"},"id":12}),
    "answerGuestQuery"                 => %({"inline_message_id":"guest-inline-id"}),
    "getBusinessConnection"            => %({"id":"business-id","user":{"id":1,"is_bot":false,"first_name":"User"},"user_chat_id":100,"date":1800000000,"rights":{"can_reply":true},"is_enabled":true}),
    "getManagedBotToken"               => %("managed-token"),
    "replaceManagedBotToken"           => %("new-managed-token"),
    "getManagedBotAccessSettings"      => %({"is_access_restricted":true,"added_users":[{"id":1,"is_bot":false,"first_name":"User"}]}),
    "getGameHighScores"                => %([{"position":1,"user":{"id":1,"is_bot":false,"first_name":"Player"},"score":100}]),
    "stopPoll"                         => %({"id":"poll-id","question":"Question?","options":[{"text":"A","voter_count":1},{"text":"B","voter_count":0}],"total_voter_count":1,"is_closed":true,"is_anonymous":true,"type":"regular","allows_multiple_answers":false,"allows_revoting":true,"members_only":false}),
    "createInvoiceLink"                => %("https://t.me/invoice/link"),
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
    @handled_update = managed_bot.bot.username
  end
end

describe TelegramBot::Bot do
  it "builds core lifecycle methods" do
    bot = RequestBuildingBot.new

    bot.log_out.should be_true
    bot.last_method.should eq("logOut")
    bot.last_force_http.should be_true
    bot.last_params.empty?.should be_true

    bot.close.should be_true
    bot.last_method.should eq("close")
    bot.last_force_http.should be_true
    bot.last_params.empty?.should be_true
  end

  it "builds sendPhoto with caption" do
    bot = RequestBuildingBot.new
    bot.send_photo(123, "photo-id", caption: "caption")

    bot.last_method.should eq("sendPhoto")
    bot.last_params["photo"].should eq("photo-id")
    bot.last_params["caption"].should eq("caption")
  end

  it "builds sendLivePhoto with current options" do
    bot = RequestBuildingBot.new

    message = bot.send_live_photo(
      123,
      "live-photo-id",
      "photo-id",
      caption: "caption",
      parse_mode: "MarkdownV2",
      show_caption_above_media: true,
      has_spoiler: true,
      allow_paid_broadcast: true
    )

    message.try(&.message_id).should eq(1)
    bot.last_method.should eq("sendLivePhoto")
    bot.last_params["chat_id"].should eq("123")
    bot.last_params["live_photo"].should eq("live-photo-id")
    bot.last_params["photo"].should eq("photo-id")
    bot.last_params["caption"].should eq("caption")
    bot.last_params["show_caption_above_media"].should eq("true")
    bot.last_params["has_spoiler"].should eq("true")
    bot.last_params["allow_paid_broadcast"].should eq("true")
  end

  it "builds sendMessage with shared params" do
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

  it "builds sendChecklist and editMessageChecklist" do
    bot = RequestBuildingBot.new
    checklist = TelegramBot::InputChecklist.new(
      "Launch",
      [
        TelegramBot::InputChecklistTask.new(1, "Ship"),
        TelegramBot::InputChecklistTask.new(2, "Announce"),
      ],
      others_can_add_tasks: true,
      others_can_mark_tasks_as_done: true
    )

    sent = bot.send_checklist("business-id", 123, checklist, protect_content: true)

    sent.try(&.message_id).should eq(1)
    bot.last_method.should eq("sendChecklist")
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["chat_id"].should eq("123")
    bot.param("checklist").should contain("InputChecklist")
    bot.last_params["protect_content"].should eq("true")

    edited = bot.edit_message_checklist("business-id", 123, 7, checklist)

    edited.try(&.message_id).should eq(1)
    bot.last_method.should eq("editMessageChecklist")
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["chat_id"].should eq("123")
    bot.last_params["message_id"].should eq("7")
    bot.param("checklist").should contain("InputChecklist")

    params = bot.serialize_for_spec({"checklist" => checklist})
    JSON.parse(params["checklist"].as(String)).should eq(JSON.parse(<<-JSON))
      {
        "title": "Launch",
        "tasks": [
          {"id": 1, "text": "Ship"},
          {"id": 2, "text": "Announce"}
        ],
        "others_can_add_tasks": true,
        "others_can_mark_tasks_as_done": true
      }
      JSON
  end

  it "builds sendAudio with the correct method" do
    bot = RequestBuildingBot.new
    bot.send_audio(123, "audio-id", duration: 10.seconds, performer: "performer", title: "title")

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

  it "builds deleteMessages" do
    bot = RequestBuildingBot.new

    bot.delete_messages(123, [7, 8]).should be_true

    bot.last_method.should eq("deleteMessages")
    bot.last_params["chat_id"].should eq("123")
    bot.last_params["message_ids"].should eq("[7, 8]")
  end

  it "builds suggested post moderation methods" do
    bot = RequestBuildingBot.new

    bot.approve_suggested_post(123, 7, send_date: 1_800_000_000).should be_true

    bot.last_method.should eq("approveSuggestedPost")
    bot.last_params["chat_id"].should eq("123")
    bot.last_params["message_id"].should eq("7")
    bot.last_params["send_date"].should eq("1800000000")

    bot.decline_suggested_post(123, 8, comment: "Needs changes").should be_true

    bot.last_method.should eq("declineSuggestedPost")
    bot.last_params["chat_id"].should eq("123")
    bot.last_params["message_id"].should eq("8")
    bot.last_params["comment"].should eq("Needs changes")
  end

  it "builds editMessageMedia" do
    bot = RequestBuildingBot.new
    media = TelegramBot::InputMediaPhoto.new(
      "photo-id",
      caption: "caption",
      caption_entities: [TelegramBot::MessageEntity.new("bold", 0, 7)],
      show_caption_above_media: true,
      has_spoiler: true
    )

    message = bot.edit_message_media(
      media,
      chat_id: 123,
      message_id: 7,
      business_connection_id: "business-id"
    )

    message.should be_a(TelegramBot::Message)
    bot.last_method.should eq("editMessageMedia")
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["chat_id"].should eq("123")
    bot.last_params["message_id"].should eq("7")
    bot.param("media").should contain("InputMediaPhoto")

    params = bot.serialize_for_spec({"media" => media})
    JSON.parse(params["media"].as(String)).should eq(JSON.parse(<<-JSON))
      {
        "type": "photo",
        "media": "photo-id",
        "caption": "caption",
        "caption_entities": [{"type": "bold", "offset": 0, "length": 7}],
        "show_caption_above_media": true,
        "has_spoiler": true
      }
      JSON
  end

  it "builds sendPoll and sendDice" do
    bot = RequestBuildingBot.new
    options = [
      TelegramBot::InputPollOption.new("A"),
      TelegramBot::InputPollOption.new("B"),
    ]

    close_date = 7.days.from_now
    open_period = 1.hour

    bot.send_poll(
      123,
      "Question?",
      options,
      allows_multiple_answers: true,
      media: TelegramBot::InputMediaLocation.new(50.45, 30.52),
      explanation_media: TelegramBot::InputMediaPhoto.new("photo-id"),
      open_period: open_period,
      close_date: close_date,
      country_codes: ["US"]
    )

    bot.last_method.should eq("sendPoll")
    bot.last_params["question"].should eq("Question?")
    bot.param("options").should contain("InputPollOption")
    bot.last_params["allows_multiple_answers"].should eq("true")
    bot.last_params["open_period"].should eq((open_period.total_seconds.to_i).to_s)
    bot.last_params["close_date"].should eq((close_date.to_unix).to_s)
    bot.last_params["country_codes"].should eq("[\"US\"]")
    bot.param("media").should contain("InputMediaLocation")
    bot.param("explanation_media").should contain("InputMediaPhoto")

    stopped_poll = bot.stop_poll(123, 1, business_connection_id: "business-id")

    stopped_poll.try(&.id).should eq("poll-id")
    bot.last_method.should eq("stopPoll")
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["chat_id"].should eq("123")
    bot.last_params["message_id"].should eq("1")

    bot.send_dice(123, "🎲", protect_content: true)

    bot.last_method.should eq("sendDice")
    bot.last_params["emoji"].should eq("🎲")
    bot.last_params["protect_content"].should eq("true")
  end

  it "builds sendPaidMedia and Star payment methods" do
    bot = RequestBuildingBot.new
    media = [
      TelegramBot::InputPaidMediaPhoto.new("photo-id"),
      TelegramBot::InputPaidMediaVideo.new("video-id", thumbnail: "thumb-id", supports_streaming: true),
      TelegramBot::InputPaidMediaLivePhoto.new("live-photo-video-id", "live-photo-id"),
    ] of TelegramBot::InputPaidMedia

    message = bot.send_paid_media(
      123,
      10,
      media,
      payload: "payload",
      caption: "caption",
      show_caption_above_media: true,
      protect_content: true
    )

    message.try(&.paid_media.try(&.star_count)).should eq(10)
    bot.last_method.should eq("sendPaidMedia")
    bot.last_params["star_count"].should eq("10")
    bot.param("media").should contain("InputPaidMediaPhoto")
    bot.last_params["payload"].should eq("payload")
    bot.last_params["show_caption_above_media"].should eq("true")

    params = bot.serialize_for_spec({"media" => media})
    JSON.parse(params["media"].as(String)).should eq(JSON.parse(<<-JSON))
      [
        {"type": "photo", "media": "photo-id"},
        {
          "type": "video",
          "media": "video-id",
          "thumbnail": "thumb-id",
          "supports_streaming": true
        },
        {
          "type": "live_photo",
          "media": "live-photo-video-id",
          "photo": "live-photo-id"
        }
      ]
      JSON

    balance = bot.get_my_star_balance

    balance.amount.should eq(100)
    balance.nanostar_amount.should eq(500)
    bot.last_method.should eq("getMyStarBalance")
    bot.last_force_http.should be_true

    transactions = bot.get_star_transactions(offset: 1, limit: 10)

    transactions.transactions.first.id.should eq("tx-id")
    transactions.transactions.first.source.as(TelegramBot::TransactionPartnerUser).paid_media_payload.should eq("payload")
    bot.last_method.should eq("getStarTransactions")
    bot.last_force_http.should be_true
    bot.last_params["offset"].should eq("1")
    bot.last_params["limit"].should eq("10")

    bot.refund_star_payment(1, "charge-id").should be_true
    bot.last_method.should eq("refundStarPayment")
    bot.last_force_http.should be_true
    bot.last_params["telegram_payment_charge_id"].should eq("charge-id")

    bot.edit_user_star_subscription(1, "charge-id", true).should be_true
    bot.last_method.should eq("editUserStarSubscription")
    bot.last_force_http.should be_true
    bot.last_params["is_canceled"].should eq("true")

    gifts = bot.get_available_gifts

    gifts.gifts.first.id.should eq("gift-id")
    gifts.gifts.first.star_count.should eq(100)
    bot.last_method.should eq("getAvailableGifts")
    bot.last_force_http.should be_true

    entities = [TelegramBot::MessageEntity.new("bold", 0, 4)]
    bot.send_gift("gift-id", user_id: 1, pay_for_upgrade: true, text: "gift", text_entities: entities).should be_true

    bot.last_method.should eq("sendGift")
    bot.last_force_http.should be_true
    bot.last_params["gift_id"].should eq("gift-id")
    bot.last_params["user_id"].should eq("1")
    bot.last_params["pay_for_upgrade"].should eq("true")
    bot.param("text_entities").should contain("MessageEntity")

    bot.gift_premium_subscription(1, 3, 1000, text: "premium").should be_true

    bot.last_method.should eq("giftPremiumSubscription")
    bot.last_force_http.should be_true
    bot.last_params["month_count"].should eq("3")
    bot.last_params["star_count"].should eq("1000")

    business_balance = bot.get_business_account_star_balance("business-id")
    business_balance.amount.should eq(250)
    bot.last_method.should eq("getBusinessAccountStarBalance")
    bot.last_force_http.should be_true

    bot.transfer_business_account_stars("business-id", 100).should be_true
    bot.last_method.should eq("transferBusinessAccountStars")
    bot.last_force_http.should be_true
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["star_count"].should eq("100")

    business_gifts = bot.get_business_account_gifts(
      "business-id",
      exclude_unsaved: true,
      sort_by_price: true,
      offset: "offset",
      limit: 10
    )
    business_gifts.total_count.should eq(1)
    business_gifts.gifts.first.owned_gift_id.should eq("owned-gift-id")
    bot.last_method.should eq("getBusinessAccountGifts")
    bot.last_params["exclude_unsaved"].should eq("true")
    bot.last_params["sort_by_price"].should eq("true")
    bot.last_params["offset"].should eq("offset")
    bot.last_params["limit"].should eq("10")

    user_gifts = bot.get_user_gifts(1, exclude_unique: true, limit: 5)
    user_gifts.total_count.should eq(1)
    bot.last_method.should eq("getUserGifts")
    bot.last_params["user_id"].should eq("1")
    bot.last_params["exclude_unique"].should eq("true")

    chat_gifts = bot.get_chat_gifts("@channel", exclude_saved: true, exclude_from_blockchain: true)
    chat_gifts.total_count.should eq(1)
    bot.last_method.should eq("getChatGifts")
    bot.last_params["chat_id"].should eq("@channel")
    bot.last_params["exclude_saved"].should eq("true")
    bot.last_params["exclude_from_blockchain"].should eq("true")

    bot.convert_gift_to_stars("business-id", "owned-gift-id").should be_true
    bot.last_method.should eq("convertGiftToStars")
    bot.last_params["owned_gift_id"].should eq("owned-gift-id")

    bot.upgrade_gift("business-id", "owned-gift-id", keep_original_details: true, star_count: 25).should be_true
    bot.last_method.should eq("upgradeGift")
    bot.last_params["keep_original_details"].should eq("true")
    bot.last_params["star_count"].should eq("25")

    bot.transfer_gift("business-id", "owned-gift-id", 123, star_count: 10).should be_true
    bot.last_method.should eq("transferGift")
    bot.last_params["new_owner_chat_id"].should eq("123")
    bot.last_params["star_count"].should eq("10")

    story_content = TelegramBot::InputStoryContentPhoto.new("photo-id")
    story_area = TelegramBot::StoryArea.new(
      TelegramBot::StoryAreaPosition.new(50.0, 50.0, 25.0, 25.0, 0.0, 10.0),
      TelegramBot::StoryAreaTypeLink.new("https://example.com")
    )

    posted_story = bot.post_story(
      "business-id",
      story_content,
      24.hours,
      caption: "story",
      areas: [story_area],
      post_to_chat_page: true,
      protect_content: true
    )
    posted_story.id.should eq(10)
    bot.last_method.should eq("postStory")
    bot.last_params["active_period"].should eq("86400")
    bot.param("content").should contain("InputStoryContentPhoto")
    bot.param("areas").should contain("StoryArea")
    bot.last_params["post_to_chat_page"].should eq("true")
    bot.last_params["protect_content"].should eq("true")

    reposted_story = bot.repost_story("business-id", 1, 10, 12.hours, post_to_chat_page: true)
    reposted_story.id.should eq(11)
    bot.last_method.should eq("repostStory")
    bot.last_params["from_chat_id"].should eq("1")
    bot.last_params["from_story_id"].should eq("10")

    edited_story = bot.edit_story("business-id", 10, story_content, caption: "updated", areas: [story_area])
    edited_story.id.should eq(12)
    bot.last_method.should eq("editStory")
    bot.last_params["story_id"].should eq("10")
    bot.last_params["caption"].should eq("updated")

    bot.delete_story("business-id", 10).should be_true
    bot.last_method.should eq("deleteStory")
    bot.last_params["story_id"].should eq("10")

    params = bot.serialize_for_spec({"content" => story_content, "areas" => [story_area]})
    JSON.parse(params["content"].as(String)).should eq(JSON.parse(<<-JSON))
      {
        "type": "photo",
        "photo": "photo-id"
      }
      JSON
    JSON.parse(params["areas"].as(String)).should eq(JSON.parse(<<-JSON))
      [{
        "position": {
          "x_percentage": 50.0,
          "y_percentage": 50.0,
          "width_percentage": 25.0,
          "height_percentage": 25.0,
          "rotation_angle": 0.0,
          "corner_radius_percentage": 10.0
        },
        "type": {
          "type": "link",
          "url": "https://example.com"
        }
      }]
      JSON

    parsed_area = TelegramBot::StoryArea.from_json(<<-JSON)
      {
        "position": {
          "x_percentage": 50.0,
          "y_percentage": 50.0,
          "width_percentage": 25.0,
          "height_percentage": 25.0,
          "rotation_angle": 0.0,
          "corner_radius_percentage": 10.0
        },
        "type": {
          "type": "weather",
          "temperature": 18.5,
          "emoji": "☀️",
          "background_color": 4294967295
        }
      }
      JSON
    parsed_area.type.should be_a(TelegramBot::StoryAreaTypeWeather)
  end

  it "builds business, guest, and managed bot methods" do
    bot = RequestBuildingBot.new
    content = TelegramBot::InputTextMessageContent.new("Guest reply")
    result = TelegramBot::InlineQueryResultArticle.new("article/1", "Article", content)

    sent = bot.answer_guest_query("guest-query-id", result)

    sent.inline_message_id.should eq("guest-inline-id")
    bot.last_method.should eq("answerGuestQuery")
    bot.param("result").should contain("InlineQueryResultArticle")

    connection = bot.get_business_connection("business-id")

    connection.id.should eq("business-id")
    connection.rights.try(&.can_reply?).should be_true
    bot.last_method.should eq("getBusinessConnection")
    bot.last_force_http.should be_true

    bot.read_business_message("business-id", 1, 10).should be_true
    bot.last_method.should eq("readBusinessMessage")
    bot.last_params["message_id"].should eq("10")

    bot.delete_business_messages("business-id", [10, 11]).should be_true
    bot.last_method.should eq("deleteBusinessMessages")
    params = bot.serialize_for_spec({"message_ids" => [10, 11]})
    params["message_ids"].should eq("[10,11]")

    bot.set_business_account_name("business-id", "First", "Last").should be_true
    bot.last_method.should eq("setBusinessAccountName")
    bot.last_params["first_name"].should eq("First")

    bot.set_business_account_username("business-id", "username").should be_true
    bot.last_method.should eq("setBusinessAccountUsername")

    bot.set_business_account_bio("business-id", "bio").should be_true
    bot.last_method.should eq("setBusinessAccountBio")

    photo = TelegramBot::InputProfilePhotoStatic.new("photo-id")
    bot.set_business_account_profile_photo("business-id", photo, is_public: true).should be_true
    bot.last_method.should eq("setBusinessAccountProfilePhoto")
    bot.param("photo").should contain("InputProfilePhotoStatic")

    bot.remove_business_account_profile_photo("business-id", is_public: true).should be_true
    bot.last_method.should eq("removeBusinessAccountProfilePhoto")

    gift_types = TelegramBot::AcceptedGiftTypes.new(true, true, true, true, false)
    bot.set_business_account_gift_settings("business-id", true, gift_types).should be_true
    bot.last_method.should eq("setBusinessAccountGiftSettings")
    bot.param("accepted_gift_types").should contain("AcceptedGiftTypes")

    bot.get_managed_bot_token(1).should eq("managed-token")
    bot.last_method.should eq("getManagedBotToken")

    bot.replace_managed_bot_token(1).should eq("new-managed-token")
    bot.last_method.should eq("replaceManagedBotToken")

    access_settings = bot.get_managed_bot_access_settings(1)
    access_settings.is_access_restricted?.should be_true
    access_settings.added_users.try(&.first.first_name).should eq("User")
    bot.last_method.should eq("getManagedBotAccessSettings")

    bot.set_managed_bot_access_settings(1, true, [2_i64]).should be_true
    bot.last_method.should eq("setManagedBotAccessSettings")
    bot.last_params["added_user_ids"].should eq("[2]")
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
    prices = [TelegramBot::LabeledPrice.from_json(%({"label":"label","amount":100}))]

    link = bot.create_invoice_link(
      "invoice title",
      "description",
      "payload",
      "XTR",
      prices,
      business_connection_id: "business-id",
      provider_token: "",
      subscription_period: 2_592_000,
      max_tip_amount: 100,
      suggested_tip_amounts: [10, 20],
      need_email: true,
      send_email_to_provider: true
    )

    link.should eq("https://t.me/invoice/link")
    bot.last_method.should eq("createInvoiceLink")
    bot.last_force_http.should be_true
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["title"].should eq("invoice title")
    bot.last_params["provider_token"].should eq("")
    bot.param("prices").should contain("LabeledPrice")
    bot.last_params["subscription_period"].should eq("2592000")
    bot.last_params["suggested_tip_amounts"].should eq("[10, 20]")
    bot.last_params["need_email"].should eq("true")
    bot.last_params["send_email_to_provider"].should eq("true")

    bot.send_invoice(
      chat_id: 123,
      title: "invoice title",
      description: "description",
      payload: "payload",
      provider_token: "provider-token",
      start_parameter: "start",
      currency: "USD",
      prices: prices,
      business_connection_id: "business-id",
      message_thread_id: 10,
      direct_messages_topic_id: 20_i64,
      subscription_period: 2_592_000,
      max_tip_amount: 100,
      suggested_tip_amounts: [10, 20],
      provider_data: "{}",
      need_email: true,
      send_email_to_provider: true,
      protect_content: true,
      allow_paid_broadcast: true,
      message_effect_id: "effect-id",
      suggested_post_parameters: TelegramBot::SuggestedPostParameters.new,
      reply_parameters: TelegramBot::ReplyParameters.new(42)
    )

    bot.last_method.should eq("sendInvoice")
    bot.last_params["title"].should eq("invoice title")
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["message_thread_id"].should eq("10")
    bot.last_params["direct_messages_topic_id"].should eq("20")
    bot.last_params["subscription_period"].should eq("2592000")
    bot.last_params["max_tip_amount"].should eq("100")
    bot.last_params["suggested_tip_amounts"].should eq("[10, 20]")
    bot.last_params["provider_data"].should eq("{}")
    bot.last_params["need_email"].should eq("true")
    bot.last_params["send_email_to_provider"].should eq("true")
    bot.last_params["protect_content"].should eq("true")
    bot.last_params["allow_paid_broadcast"].should eq("true")
    bot.last_params["message_effect_id"].should eq("effect-id")
    bot.param("suggested_post_parameters").should contain("SuggestedPostParameters")
    bot.param("reply_parameters").should contain("ReplyParameters")
    bot.last_params.has_key?("tilte").should be_false
  end

  it "builds setPassportDataErrors" do
    bot = RequestBuildingBot.new
    errors = [
      TelegramBot::PassportElementError.data_field(
        "personal_details",
        "birth_date",
        "data-hash",
        "Birth date is invalid"
      ),
      TelegramBot::PassportElementError.front_side(
        "passport",
        "file-hash",
        "Front side is blurry"
      ),
    ]

    bot.set_passport_data_errors(123, errors).should be_true

    bot.last_method.should eq("setPassportDataErrors")
    bot.last_force_http.should be_true
    bot.last_params["user_id"].should eq("123")
    bot.param("errors").should contain("PassportElementError")

    params = bot.serialize_for_spec({"errors" => errors})
    JSON.parse(params["errors"].as(String)).should eq(JSON.parse(<<-JSON))
      [
        {
          "source": "data",
          "type": "personal_details",
          "message": "Birth date is invalid",
          "field_name": "birth_date",
          "data_hash": "data-hash"
        },
        {
          "source": "front_side",
          "type": "passport",
          "message": "Front side is blurry",
          "file_hash": "file-hash"
        }
      ]
      JSON
  end

  it "builds sendContact with disable_notification" do
    bot = RequestBuildingBot.new
    bot.send_contact(123, "+15550100", "First", disable_notification: true)

    bot.last_method.should eq("sendContact")
    bot.last_params["disable_notification"].should eq("true")

    bot.edit_message_live_location(
      50.45,
      30.52,
      business_connection_id: "business-id",
      chat_id: 123,
      message_id: 7,
      live_period: 1.hour,
      horizontal_accuracy: 10.5,
      heading: 90,
      proximity_alert_radius: 100
    )
    bot.last_method.should eq("editMessageLiveLocation")
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["live_period"].should eq("3600")
    bot.last_params["horizontal_accuracy"].should eq("10.5")
    bot.last_params["heading"].should eq("90")
    bot.last_params["proximity_alert_radius"].should eq("100")

    bot.stop_message_live_location(business_connection_id: "business-id", chat_id: 123, message_id: 7)
    bot.last_method.should eq("stopMessageLiveLocation")
    bot.last_params["business_connection_id"].should eq("business-id")
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

  it "serializes all input media variants" do
    bot = RequestBuildingBot.new
    media = [
      TelegramBot::InputMediaAnimation.new(
        "animation-id",
        thumbnail: "thumb-id",
        caption: "animation",
        show_caption_above_media: true,
        width: 320,
        height: 240,
        duration: 10,
        has_spoiler: true
      ),
      TelegramBot::InputMediaAudio.new(
        "audio-id",
        thumbnail: "thumb-id",
        caption: "audio",
        duration: 10,
        performer: "performer",
        title: "title"
      ),
      TelegramBot::InputMediaDocument.new(
        "document-id",
        thumbnail: "thumb-id",
        caption: "document",
        disable_content_type_detection: true
      ),
      TelegramBot::InputMediaLivePhoto.new(
        "live-photo-video-id",
        "live-photo-id",
        caption: "live photo",
        show_caption_above_media: true,
        has_spoiler: true
      ),
      TelegramBot::InputMediaVideo.new(
        "video-id",
        thumbnail: "thumb-id",
        cover: "cover-id",
        start_timestamp: 5,
        caption: "video",
        show_caption_above_media: true,
        width: 320,
        height: 240,
        duration: 10,
        supports_streaming: true,
        has_spoiler: true
      ),
    ] of TelegramBot::InputMedia

    params = bot.serialize_for_spec({"media" => media})
    JSON.parse(params["media"].as(String)).should eq(JSON.parse(<<-JSON))
      [
        {
          "type": "animation",
          "media": "animation-id",
          "thumbnail": "thumb-id",
          "caption": "animation",
          "show_caption_above_media": true,
          "width": 320,
          "height": 240,
          "duration": 10,
          "has_spoiler": true
        },
        {
          "type": "audio",
          "media": "audio-id",
          "thumbnail": "thumb-id",
          "caption": "audio",
          "duration": 10,
          "performer": "performer",
          "title": "title"
        },
        {
          "type": "document",
          "media": "document-id",
          "thumbnail": "thumb-id",
          "caption": "document",
          "disable_content_type_detection": true
        },
        {
          "type": "live_photo",
          "media": "live-photo-video-id",
          "photo": "live-photo-id",
          "caption": "live photo",
          "show_caption_above_media": true,
          "has_spoiler": true
        },
        {
          "type": "video",
          "media": "video-id",
          "thumbnail": "thumb-id",
          "cover": "cover-id",
          "start_timestamp": 5,
          "caption": "video",
          "show_caption_above_media": true,
          "width": 320,
          "height": 240,
          "duration": 10,
          "supports_streaming": true,
          "has_spoiler": true
        }
      ]
      JSON
  end

  it "keeps wrappers passing native arrays to the request layer" do
    bot = RequestBuildingBot.new
    content = TelegramBot::InputTextMessageContent.new("Article details")
    results = [TelegramBot::InlineQueryResultArticle.new("article/1", "Article", content)] of TelegramBot::InlineQueryResult
    button = TelegramBot::InlineQueryResultsButton.new("Open", start_parameter: "start")

    bot.answer_inline_query("inline-query-id", results, cache_time: 60, is_personal: true, next_offset: "next", button: button)

    bot.last_method.should eq("answerInlineQuery")
    bot.last_params["cache_time"].should eq("60")
    bot.last_params["is_personal"].should eq("true")
    bot.last_params["next_offset"].should eq("next")
    if results_param = bot.last_params["results"]?
      results_param.should contain("InlineQueryResultArticle")
    else
      fail "expected results param"
    end
    bot.param("button").should contain("InlineQueryResultsButton")
  end

  it "serializes inline keyboard button fields" do
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

  it "serializes reply keyboard button fields" do
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
            "bot_administrator_rights": {
              "is_anonymous": false,
              "can_manage_chat": false,
              "can_delete_messages": false,
              "can_manage_video_chats": false,
              "can_restrict_members": false,
              "can_promote_members": false,
              "can_change_info": false,
              "can_invite_users": true,
              "can_post_stories": false,
              "can_edit_stories": false,
              "can_delete_stories": false
            },
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

    photo = TelegramBot::InputProfilePhotoStatic.new("attach://photo")
    bot.set_my_profile_photo(photo).should be_true
    bot.last_method.should eq("setMyProfilePhoto")
    bot.last_force_http.should be_true
    bot.param("photo").should contain("InputProfilePhotoStatic")

    animated_photo = TelegramBot::InputProfilePhotoAnimated.new("attach://animation", main_frame_timestamp: 1.5)
    animated_params = bot.serialize_for_spec({"photo" => animated_photo})
    JSON.parse(animated_params["photo"].as(String)).should eq(JSON.parse(<<-JSON))
      {
        "type": "animated",
        "animation": "attach://animation",
        "main_frame_timestamp": 1.5
      }
      JSON

    bot.remove_my_profile_photo.should be_true
    bot.last_method.should eq("removeMyProfilePhoto")
    bot.last_force_http.should be_true
    bot.last_params.empty?.should be_true

    menu_button = TelegramBot::MenuButtonWebApp.new("Open", TelegramBot::WebAppInfo.new("https://example.com/app"))
    bot.set_chat_menu_button(123, menu_button).should be_true
    bot.last_method.should eq("setChatMenuButton")
    bot.last_force_http.should be_true
    bot.last_params["chat_id"].should eq("123")
    bot.param("menu_button").should contain("MenuButtonWebApp")

    current_menu_button = bot.get_chat_menu_button(123)
    current_menu_button.should be_a(TelegramBot::MenuButtonWebApp)
    current_web_app_button = current_menu_button.as(TelegramBot::MenuButtonWebApp)
    current_web_app_button.text.should eq("Open")
    current_web_app_button.web_app.url.should eq("https://example.com/app")
    bot.last_method.should eq("getChatMenuButton")
    bot.last_force_http.should be_true

    bot.verify_user(123, custom_description: "Verified").should be_true
    bot.last_method.should eq("verifyUser")
    bot.last_force_http.should be_true
    bot.last_params["user_id"].should eq("123")
    bot.last_params["custom_description"].should eq("Verified")

    bot.verify_chat("@channel", custom_description: "Official").should be_true
    bot.last_method.should eq("verifyChat")
    bot.last_force_http.should be_true
    bot.last_params["chat_id"].should eq("@channel")
    bot.last_params["custom_description"].should eq("Official")

    bot.remove_user_verification(123).should be_true
    bot.last_method.should eq("removeUserVerification")
    bot.last_force_http.should be_true
    bot.last_params["user_id"].should eq("123")

    bot.remove_chat_verification("@channel").should be_true
    bot.last_method.should eq("removeChatVerification")
    bot.last_force_http.should be_true
    bot.last_params["chat_id"].should eq("@channel")

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

    audios = bot.get_user_profile_audios(1, offset: 2, limit: 3)
    audios.total_count.should eq(1)
    audios.audios.first.file_id.should eq("audio-id")
    bot.last_method.should eq("getUserProfileAudios")
    bot.last_force_http.should be_true
    bot.last_params["offset"].should eq("2")
    bot.last_params["limit"].should eq("3")

    bot.set_user_emoji_status(1, "emoji-id", 1_800_000_000).should be_true
    bot.last_method.should eq("setUserEmojiStatus")
    bot.last_force_http.should be_true
    bot.last_params["emoji_status_custom_emoji_id"].should eq("emoji-id")
    bot.last_params["emoji_status_expiration_date"].should eq("1800000000")

    permissions = TelegramBot::ChatPermissions.new(
      can_send_messages: true,
      can_send_photos: true,
      can_edit_tag: true,
      can_react_to_messages: true
    )

    bot.get_chat_administrators(123, return_bots: true)
    bot.last_method.should eq("getChatAdministrators")
    bot.last_params["chat_id"].should eq("123")
    bot.last_params["return_bots"].should eq("true")

    bot.send_chat_action("@group", "typing", business_connection_id: "business-id", message_thread_id: 10).should be_true
    bot.last_method.should eq("sendChatAction")
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["message_thread_id"].should eq("10")
    bot.last_params["action"].should eq("typing")

    until_date = 7.days.from_now
    bot.ban_chat_member("@group", 123, until_date: until_date, revoke_messages: true).should be_true
    bot.last_method.should eq("banChatMember")
    bot.last_params["revoke_messages"].should eq("true")
    bot.last_params["until_date"].should eq((until_date.to_unix).to_s)

    bot.ban_chat_sender_chat("@group", -100).should be_true
    bot.last_method.should eq("banChatSenderChat")
    bot.last_params["sender_chat_id"].should eq("-100")

    bot.unban_chat_sender_chat("@group", -100).should be_true
    bot.last_method.should eq("unbanChatSenderChat")
    bot.last_params["sender_chat_id"].should eq("-100")

    bot.restrict_chat_member("@group", 123, permissions: permissions, use_independent_chat_permissions: true)

    bot.last_method.should eq("restrictChatMember")
    bot.param("permissions").should contain("ChatPermissions")
    bot.last_params["use_independent_chat_permissions"].should eq("true")

    bot.promote_chat_member("@group", 123, can_manage_tags: true).should be_true
    bot.last_method.should eq("promoteChatMember")
    bot.last_params["can_manage_tags"].should eq("true")

    bot.set_chat_permissions("@group", permissions, use_independent_chat_permissions: true).should be_true
    bot.last_method.should eq("setChatPermissions")
    bot.param("permissions").should contain("ChatPermissions")
    bot.last_params["use_independent_chat_permissions"].should eq("true")

    bot.set_chat_administrator_custom_title("@group", 123, "Admin").should be_true
    bot.last_method.should eq("setChatAdministratorCustomTitle")
    bot.last_params["custom_title"].should eq("Admin")

    bot.set_chat_member_tag("@group", 123, "Trusted").should be_true
    bot.last_method.should eq("setChatMemberTag")
    bot.last_params["tag"].should eq("Trusted")

    media_permissions = TelegramBot::ChatPermissions.new(
      can_send_audios: true,
      can_send_documents: true,
      can_send_photos: true,
      can_send_videos: true,
      can_send_video_notes: true,
      can_send_voice_notes: true
    )
    params = bot.serialize_for_spec({"permissions" => media_permissions})
    JSON.parse(params["permissions"].as(String)).should eq(JSON.parse(<<-JSON))
      {
        "can_send_audios": true,
        "can_send_documents": true,
        "can_send_photos": true,
        "can_send_videos": true,
        "can_send_video_notes": true,
        "can_send_voice_notes": true
      }
      JSON

    expire_date = 7.days.from_now
    invite = bot.create_chat_invite_link("@group", name: "Invite", expire_date: expire_date, creates_join_request: true)

    invite.try(&.invite_link).should eq("https://t.me/+invite")
    invite.try(&.creates_join_request?).should be_true
    bot.last_method.should eq("createChatInviteLink")
    bot.last_params["name"].should eq("Invite")
    bot.last_params["expire_date"].should eq((expire_date.to_unix).to_s)

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

    bot.get_chat_member_count("@group").should eq(12)
    bot.last_method.should eq("getChatMemberCount")

    personal_messages = bot.get_user_personal_chat_messages(1, 1)
    personal_messages.first.text.should eq("Personal")
    bot.last_method.should eq("getUserPersonalChatMessages")
    bot.last_force_http.should be_true
    bot.last_params["limit"].should eq("1")

    boosts = bot.get_user_chat_boosts("@group", 123)
    boosts.boosts.first.boost_id.should eq("boost-id")
    bot.last_method.should eq("getUserChatBoosts")
    bot.last_params["user_id"].should eq("123")

    JSON.parse(permissions.to_json).should eq(JSON.parse(<<-JSON))
      {
        "can_send_messages": true,
        "can_send_photos": true,
        "can_edit_tag": true,
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

    bot.delete_message_reaction("@group", 10, user_id: 123).should be_true
    bot.last_method.should eq("deleteMessageReaction")
    bot.last_params["user_id"].should eq("123")
    bot.last_params.has_key?("reaction").should be_false

    bot.delete_all_message_reactions("@group", actor_chat_id: -100).should be_true
    bot.last_method.should eq("deleteAllMessageReactions")
    bot.last_params["actor_chat_id"].should eq("-100")
    bot.last_params.has_key?("message_id").should be_false

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

    bot.unpin_all_chat_messages("@group").should be_true
    bot.last_method.should eq("unpinAllChatMessages")
  end

  it "builds game methods" do
    bot = RequestBuildingBot.new
    reply_markup = TelegramBot::InlineKeyboardMarkup.new([
      [TelegramBot::InlineKeyboardButton.new("Play", callback_game: TelegramBot::CallbackGame.from_json("{}"))],
    ])
    reply_parameters = TelegramBot::ReplyParameters.new(10)

    message = bot.send_game(
      123,
      "game",
      business_connection_id: "business-id",
      message_thread_id: 20,
      disable_notification: true,
      protect_content: true,
      allow_paid_broadcast: true,
      message_effect_id: "effect-id",
      reply_parameters: reply_parameters,
      reply_markup: reply_markup
    )

    message.try(&.message_id).should eq(1)
    bot.last_method.should eq("sendGame")
    bot.last_params["business_connection_id"].should eq("business-id")
    bot.last_params["message_thread_id"].should eq("20")
    bot.last_params["game_short_name"].should eq("game")
    bot.last_params["protect_content"].should eq("true")
    bot.last_params["allow_paid_broadcast"].should eq("true")
    bot.last_params["message_effect_id"].should eq("effect-id")
    bot.param("reply_parameters").should contain("ReplyParameters")
    bot.param("reply_markup").should contain("InlineKeyboardMarkup")

    scored = bot.set_game_score(1, 100, force: true, disable_edit_message: true, chat_id: 123, message_id: 10)

    scored.should be_a(TelegramBot::Message)
    bot.last_method.should eq("setGameScore")
    bot.last_params["force"].should eq("true")
    bot.last_params["disable_edit_message"].should eq("true")
    bot.last_params["chat_id"].should eq("123")
    bot.last_params["message_id"].should eq("10")

    scores = bot.get_game_high_scores(1, chat_id: 123, message_id: 10)

    scores.first.score.should eq(100)
    bot.last_method.should eq("getGameHighScores")
    bot.last_params["user_id"].should eq("1")
    bot.last_params["chat_id"].should eq("123")
  end

  it "builds sticker set methods" do
    bot = RequestBuildingBot.new
    input_sticker = TelegramBot::InputSticker.new(
      "attach://sticker",
      "static",
      ["🙂"],
      keywords: ["crystal"]
    )

    sticker_set = bot.get_sticker_set("set_name")
    sticker_set.try(&.sticker_type).should eq("regular")
    sticker_set.try(&.stickers.first.file_unique_id).should eq("sticker-id-unique")
    bot.last_method.should eq("getStickerSet")

    custom_emoji_stickers = bot.get_custom_emoji_stickers(["emoji-id"])
    custom_emoji_stickers.first.custom_emoji_id.should eq("emoji-id")
    bot.last_method.should eq("getCustomEmojiStickers")
    bot.last_params["custom_emoji_ids"].should eq("[\"emoji-id\"]")

    ::File.tempfile("sticker") do |file|
      uploaded = bot.upload_sticker_file(1, file, "static")
      uploaded.try(&.file_id).should eq("uploaded-sticker-id")
    end
    bot.last_method.should eq("uploadStickerFile")
    bot.last_params.has_key?("png_sticker").should be_false
    bot.last_params["sticker_format"].should eq("static")

    bot.create_new_sticker_set(
      1,
      "set_name",
      "Sticker Set",
      [input_sticker],
      sticker_type: "regular",
      needs_repainting: true
    ).should be_true
    bot.last_method.should eq("createNewStickerSet")
    bot.param("stickers").should contain("InputSticker")
    bot.last_params.has_key?("png_sticker").should be_false
    bot.last_params.has_key?("emojis").should be_false
    bot.last_params.has_key?("contains_masks").should be_false

    bot.add_sticker_to_set(1, "set_name", input_sticker).should be_true
    bot.last_method.should eq("addStickerToSet")
    bot.param("sticker").should contain("InputSticker")
    bot.last_params.has_key?("png_sticker").should be_false

    bot.replace_sticker_in_set(1, "set_name", "old-sticker-id", input_sticker).should be_true
    bot.last_method.should eq("replaceStickerInSet")
    bot.last_params["old_sticker"].should eq("old-sticker-id")
    bot.param("sticker").should contain("InputSticker")

    bot.set_sticker_position_in_set("sticker-id", 2).should be_true
    bot.last_method.should eq("setStickerPositionInSet")

    bot.set_sticker_emoji_list("sticker-id", ["🙂"]).should be_true
    bot.last_method.should eq("setStickerEmojiList")
    bot.last_params["emoji_list"].should eq("[\"🙂\"]")

    bot.set_sticker_keywords("sticker-id", ["crystal"]).should be_true
    bot.last_method.should eq("setStickerKeywords")
    bot.last_params["keywords"].should eq("[\"crystal\"]")

    mask_position = TelegramBot::MaskPosition.new("forehead", 0.0, 0.0, 1.0)
    bot.set_sticker_mask_position("sticker-id", mask_position).should be_true
    bot.last_method.should eq("setStickerMaskPosition")
    bot.param("mask_position").should contain("MaskPosition")

    bot.set_sticker_set_title("set_name", "New Title").should be_true
    bot.last_method.should eq("setStickerSetTitle")
    bot.last_params["title"].should eq("New Title")

    bot.set_sticker_set_thumbnail("set_name", 1, "static", "thumbnail-id").should be_true
    bot.last_method.should eq("setStickerSetThumbnail")
    bot.last_params["thumbnail"].should eq("thumbnail-id")
    bot.last_params["format"].should eq("static")

    bot.set_custom_emoji_sticker_set_thumbnail("set_name", "emoji-id").should be_true
    bot.last_method.should eq("setCustomEmojiStickerSetThumbnail")
    bot.last_params["custom_emoji_id"].should eq("emoji-id")

    bot.delete_sticker_from_set("sticker-id").should be_true
    bot.last_method.should eq("deleteStickerFromSet")

    bot.delete_sticker_set("set_name").should be_true
    bot.last_method.should eq("deleteStickerSet")
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

  it "dispatches update fields" do
    cases = {
      {
        <<-JSON,
          {
            "update_id": 1,
            "business_connection": {
              "id": "business-connection-id",
              "user": {"id": 1, "is_bot": false, "first_name": "User"},
              "user_chat_id": 100,
              "date": 1800000000,
              "is_enabled": true
            }
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
              "option_ids": [0],
              "option_persistent_ids": ["option-0"]
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
              "user": {"id": 1, "is_bot": false, "first_name": "User"},
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
