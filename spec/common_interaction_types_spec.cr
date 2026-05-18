require "./spec_helper"

describe TelegramBot::ResponseParameters do
  it "parses error response parameters" do
    parameters = TelegramBot::ResponseParameters.from_json(<<-JSON)
      {
        "migrate_to_chat_id": -1001234567890,
        "retry_after": 30
      }
      JSON

    parameters.migrate_to_chat_id.should eq(-1_001_234_567_890)
    parameters.retry_after.should eq(30)
  end
end

describe TelegramBot::Message do
  it "parses dice, poll, and forum service fields" do
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 1,
        "date": 0,
        "chat": {"id": 1, "type": "private"},
        "dice": {"emoji": "🎲", "value": 6},
        "poll": {
          "id": "poll-id",
          "question": "Question?",
          "options": [
            {
              "persistent_id": "option-id",
              "text": "Option",
              "voter_count": 1,
              "media": {"photo": [{"file_id": "file-id", "file_unique_id": "file-unique-id", "width": 1, "height": 1}]}
            }
          ],
          "total_voter_count": 1,
          "is_closed": false,
          "is_anonymous": false,
          "type": "regular",
          "allows_multiple_answers": false,
          "allows_revoting": true,
          "media": {"photo": [{"file_id": "file-id", "file_unique_id": "file-unique-id", "width": 1, "height": 1}]}
        },
        "forum_topic_created": {
          "name": "Topic",
          "icon_color": 16711680,
          "icon_custom_emoji_id": "emoji-id",
          "is_name_implicit": true
        },
        "forum_topic_edited": {
          "name": "New Topic",
          "icon_custom_emoji_id": ""
        },
        "forum_topic_closed": {},
        "forum_topic_reopened": {},
        "general_forum_topic_hidden": {},
        "general_forum_topic_unhidden": {},
        "poll_option_added": {
          "poll_message": {
            "message_id": 2,
            "date": 0,
            "chat": {"id": 1, "type": "private"},
            "poll": {
              "id": "poll-id",
              "question": "Question?",
              "options": [{"text": "Option", "voter_count": 1}],
              "total_voter_count": 1,
              "is_closed": false,
              "is_anonymous": false,
              "type": "regular",
              "allows_multiple_answers": false
            }
          },
          "option_persistent_id": "added-option-id",
          "option_text": "Added"
        },
        "poll_option_deleted": {
          "poll_message": {
            "message_id": 3,
            "date": 0,
            "chat": {"id": 1, "type": "private"}
          },
          "option_persistent_id": "deleted-option-id",
          "option_text": "Deleted"
        }
      }
      JSON

    message.dice.try(&.value).should eq(6)
    message.poll.try(&.id).should eq("poll-id")
    message.poll.try(&.options.try(&.first.persistent_id)).should eq("option-id")
    message.poll.try(&.options.try(&.first.media.try(&.photo.try(&.first.file_id)))).should eq("file-id")
    message.poll.try(&.allows_revoting?).should be_true
    message.poll.try(&.media.try(&.photo.try(&.first.file_id))).should eq("file-id")
    message.forum_topic_created.try(&.name).should eq("Topic")
    message.forum_topic_created.try(&.is_name_implicit?).should be_true
    message.forum_topic_edited.try(&.name).should eq("New Topic")
    message.forum_topic_closed.should be_a(TelegramBot::ForumTopicClosed)
    message.forum_topic_reopened.should be_a(TelegramBot::ForumTopicReopened)
    message.general_forum_topic_hidden.should be_a(TelegramBot::GeneralForumTopicHidden)
    message.general_forum_topic_unhidden.should be_a(TelegramBot::GeneralForumTopicUnhidden)
    message.poll_option_added.try(&.option_persistent_id).should eq("added-option-id")
    message.poll_option_added.try(&.poll_message.try(&.message_id)).should eq(2)
    message.poll_option_deleted.try(&.option_persistent_id).should eq("deleted-option-id")
    message.poll_option_deleted.try(&.poll_message.try(&.message_id)).should eq(3)
  end
end

describe TelegramBot::ChatBoost do
  it "parses typed boost sources" do
    boosts = TelegramBot::UserChatBoosts.from_json(<<-JSON)
      {
        "boosts": [
          {
            "boost_id": "premium-boost",
            "add_date": 1,
            "expiration_date": 2,
            "source": {"source": "premium", "user": {"id": 1, "is_bot": false, "first_name": "User"}}
          },
          {
            "boost_id": "giveaway-boost",
            "add_date": 3,
            "expiration_date": 4,
            "source": {
              "source": "giveaway",
              "giveaway_message_id": 10,
              "prize_star_count": 100,
              "is_unclaimed": true
            }
          }
        ]
      }
      JSON
    removed = TelegramBot::ChatBoostRemoved.from_json(<<-JSON)
      {
        "chat": {"id": 1, "type": "private"},
        "boost_id": "removed-boost",
        "remove_date": 5,
        "source": {"source": "gift_code", "user": {"id": 2, "is_bot": false, "first_name": "Gift"}}
      }
      JSON

    boosts.boosts.first.source.try(&.source).should eq("premium")
    boosts.boosts.first.source.try(&.user.try(&.first_name)).should eq("User")
    boosts.boosts.last.source.try(&.giveaway_message_id).should eq(10)
    boosts.boosts.last.source.try(&.is_unclaimed?).should be_true
    removed.source.try(&.source).should eq("gift_code")
    removed.source.try(&.user.try(&.first_name)).should eq("Gift")
  end
end

describe TelegramBot::InputPollOption do
  it "serializes poll option input" do
    option = TelegramBot::InputPollOption.new(
      "Option",
      text_entities: [TelegramBot::MessageEntity.new("custom_emoji", 0, 2, custom_emoji_id: "emoji-id")],
      media: TelegramBot::InputMediaSticker.new("sticker-id")
    )

    JSON.parse(option.to_json).should eq(JSON.parse(<<-JSON))
      {
        "text": "Option",
        "text_entities": [
          {
            "type": "custom_emoji",
            "offset": 0,
            "length": 2,
            "custom_emoji_id": "emoji-id"
          }
        ],
        "media": {
          "type": "sticker",
          "media": "sticker-id"
        }
      }
      JSON
  end

  it "serializes poll media inputs" do
    location = TelegramBot::InputMediaLocation.new(
      50.45,
      30.52,
      horizontal_accuracy: 10.5
    )
    venue = TelegramBot::InputMediaVenue.new(
      50.45,
      30.52,
      "Venue",
      "Main Street",
      google_place_id: "place-id",
      google_place_type: "restaurant"
    )

    JSON.parse(location.to_json).should eq(JSON.parse(<<-JSON))
      {
        "type": "location",
        "latitude": 50.45,
        "longitude": 30.52,
        "horizontal_accuracy": 10.5
      }
      JSON
    JSON.parse(venue.to_json).should eq(JSON.parse(<<-JSON))
      {
        "type": "venue",
        "latitude": 50.45,
        "longitude": 30.52,
        "title": "Venue",
        "address": "Main Street",
        "google_place_id": "place-id",
        "google_place_type": "restaurant"
      }
      JSON
  end
end

describe TelegramBot::ReactionType do
  it "parses reaction updates and serializes reaction types" do
    update = TelegramBot::MessageReactionUpdated.from_json(<<-JSON)
      {
        "chat": {"id": 1, "type": "private"},
        "message_id": 1,
        "date": 0,
        "old_reaction": [{"type": "emoji", "emoji": "👍"}],
        "new_reaction": [{"type": "custom_emoji", "custom_emoji_id": "emoji-id"}]
      }
      JSON
    count = TelegramBot::ReactionCount.from_json(<<-JSON)
      {
        "type": {"type": "paid"},
        "total_count": 3
      }
      JSON

    update.chat.id.should eq(1)
    update.message_id.should eq(1)
    update.date.should eq(0)
    update.old_reaction.first.emoji.should eq("👍")
    update.new_reaction.first.custom_emoji_id.should eq("emoji-id")
    count.type.type.should eq("paid")
    count.total_count.should eq(3)

    JSON.parse(TelegramBot::ReactionTypeEmoji.new("👍").to_json).should eq(JSON.parse(%({"type":"emoji","emoji":"👍"})))
    JSON.parse(TelegramBot::ReactionTypeCustomEmoji.new("emoji-id").to_json).should eq(JSON.parse(%({"type":"custom_emoji","custom_emoji_id":"emoji-id"})))
    JSON.parse(TelegramBot::ReactionTypePaid.new.to_json).should eq(JSON.parse(%({"type":"paid"})))
  end
end

describe TelegramBot::ForumTopic do
  it "parses forum topics" do
    topic = TelegramBot::ForumTopic.from_json(<<-JSON)
      {
        "message_thread_id": 42,
        "name": "Topic",
        "icon_color": 16711680,
        "icon_custom_emoji_id": "emoji-id"
      }
      JSON

    topic.message_thread_id.should eq(42)
    topic.name.should eq("Topic")
    topic.icon_custom_emoji_id.should eq("emoji-id")
  end
end

describe TelegramBot::Contact do
  it "parses contact, location, and venue fields" do
    contact = TelegramBot::Contact.from_json(<<-JSON)
      {
        "phone_number": "+15550100",
        "first_name": "First",
        "last_name": "Last",
        "user_id": 9007199254740991,
        "vcard": "BEGIN:VCARD"
      }
      JSON
    location = TelegramBot::Location.from_json(<<-JSON)
      {
        "latitude": 50.45,
        "longitude": 30.52,
        "horizontal_accuracy": 10.5,
        "live_period": 60,
        "heading": 90,
        "proximity_alert_radius": 100
      }
      JSON
    venue = TelegramBot::Venue.from_json(<<-JSON)
      {
        "location": {"latitude": 50.45, "longitude": 30.52},
        "title": "Venue",
        "address": "Main Street",
        "foursquare_id": "foursquare-id",
        "foursquare_type": "food/restaurant",
        "google_place_id": "place-id",
        "google_place_type": "restaurant"
      }
      JSON

    contact.user_id.should eq(9_007_199_254_740_991)
    contact.vcard.should eq("BEGIN:VCARD")
    location.horizontal_accuracy.should eq(10.5)
    location.live_period.should eq(60)
    location.heading.should eq(90)
    location.proximity_alert_radius.should eq(100)
    venue.google_place_id.should eq("place-id")
    venue.google_place_type.should eq("restaurant")
  end
end

describe TelegramBot::InputMessageContent do
  it "serializes invoice content" do
    content = TelegramBot::InputInvoiceMessageContent.new(
      "Title",
      "Description",
      "payload",
      "XTR",
      [TelegramBot::LabeledPrice.new("Stars", 100)],
      provider_token: "",
      suggested_tip_amounts: [10, 20],
      need_email: true
    )
    json = JSON.parse(content.to_json)

    json["title"].should eq("Title")
    json["prices"][0]["label"].should eq("Stars")
    json["provider_token"].should eq("")
    json["suggested_tip_amounts"][1].should eq(20)
    json["need_email"].should be_true
  end

  it "serializes text content entities and link preview options" do
    content = TelegramBot::InputTextMessageContent.new(
      "Visit https://example.com",
      entities: [TelegramBot::MessageEntity.new("url", 6, 19)],
      link_preview_options: TelegramBot::LinkPreviewOptions.new(is_disabled: true)
    )
    json = JSON.parse(content.to_json)

    json["message_text"].should eq("Visit https://example.com")
    json["entities"][0]["type"].should eq("url")
    json["link_preview_options"]["is_disabled"].should be_true
  end

  it "serializes inline location, venue, and contact content" do
    location = TelegramBot::InputLocationMessageContent.new(
      50.45,
      30.52,
      horizontal_accuracy: 10.5,
      live_period: 60,
      heading: 90,
      proximity_alert_radius: 100
    )
    venue = TelegramBot::InputVenueMessageContent.new(
      50.45,
      30.52,
      "Venue",
      "Main Street",
      google_place_id: "place-id",
      google_place_type: "restaurant"
    )
    contact = TelegramBot::InputContactMessageContent.new(
      "+15550100",
      "First",
      vcard: "BEGIN:VCARD"
    )

    JSON.parse(location.to_json).should eq(JSON.parse(<<-JSON))
      {
        "latitude": 50.45,
        "longitude": 30.52,
        "horizontal_accuracy": 10.5,
        "live_period": 60,
        "heading": 90,
        "proximity_alert_radius": 100
      }
      JSON
    JSON.parse(venue.to_json).should eq(JSON.parse(<<-JSON))
      {
        "latitude": 50.45,
        "longitude": 30.52,
        "title": "Venue",
        "address": "Main Street",
        "google_place_id": "place-id",
        "google_place_type": "restaurant"
      }
      JSON
    JSON.parse(contact.to_json).should eq(JSON.parse(<<-JSON))
      {
        "phone_number": "+15550100",
        "first_name": "First",
        "vcard": "BEGIN:VCARD"
      }
      JSON
  end
end

describe TelegramBot::InlineQueryResult do
  it "serializes caption fields for media results" do
    entity = TelegramBot::MessageEntity.new("bold", 0, 4)
    photo = TelegramBot::InlineQueryResultPhoto.new(
      "photo-1",
      "https://example.com/photo.jpg",
      "https://example.com/thumb.jpg",
      caption: "Bold",
      caption_entities: [entity],
      show_caption_above_media: true
    )
    cached_video = TelegramBot::InlineQueryResultCachedVideo.new(
      "video-1",
      "video-file-id",
      "Video",
      caption: "Bold",
      parse_mode: "MarkdownV2",
      caption_entities: [entity],
      show_caption_above_media: true
    )
    audio = TelegramBot::InlineQueryResultAudio.new(
      "audio-1",
      "https://example.com/audio.mp3",
      "Audio",
      caption: "Bold",
      caption_entities: [entity]
    )

    photo_json = JSON.parse(photo.to_json)
    cached_video_json = JSON.parse(cached_video.to_json)
    audio_json = JSON.parse(audio.to_json)

    photo_json["caption_entities"][0]["type"].should eq("bold")
    photo_json["show_caption_above_media"].should be_true
    cached_video_json["parse_mode"].should eq("MarkdownV2")
    cached_video_json["show_caption_above_media"].should be_true
    audio_json["caption_entities"][0]["length"].should eq(4)
  end

  it "serializes inline query result buttons and games" do
    button = TelegramBot::InlineQueryResultsButton.new(
      "Open app",
      web_app: TelegramBot::WebAppInfo.new("https://example.com/app")
    )
    game = TelegramBot::InlineQueryResultGame.new(
      "game-1",
      "short_name",
      reply_markup: TelegramBot::InlineKeyboardMarkup.new([
        [TelegramBot::InlineKeyboardButton.new("Play", callback_game: TelegramBot::CallbackGame.from_json("{}"))],
      ])
    )

    button_json = JSON.parse(button.to_json)
    game_json = JSON.parse(game.to_json)

    button_json["text"].should eq("Open app")
    button_json["web_app"]["url"].should eq("https://example.com/app")
    game_json["type"].should eq("game")
    game_json["game_short_name"].should eq("short_name")
    game_json["reply_markup"]["inline_keyboard"][0][0]["text"].should eq("Play")
  end

  it "serializes location, venue, and contact result fields" do
    location = TelegramBot::InlineQueryResultLocation.new(
      "location-id",
      50.45,
      30.52,
      "Location",
      horizontal_accuracy: 10.5,
      live_period: 60,
      heading: 90,
      proximity_alert_radius: 100,
      thumbnail_url: "https://example.com/thumb.jpg"
    )
    venue = TelegramBot::InlineQueryResultVenue.new(
      "venue-id",
      50.45,
      30.52,
      "Venue",
      "Main Street",
      google_place_id: "place-id",
      google_place_type: "restaurant"
    )
    contact = TelegramBot::InlineQueryResultContact.new(
      "contact-id",
      "+15550100",
      "First",
      vcard: "BEGIN:VCARD"
    )

    JSON.parse(location.to_json)["horizontal_accuracy"].should eq(JSON.parse("10.5"))
    JSON.parse(location.to_json)["proximity_alert_radius"].should eq(JSON.parse("100"))
    JSON.parse(venue.to_json)["google_place_id"].should eq(JSON.parse(%("place-id")))
    JSON.parse(venue.to_json)["google_place_type"].should eq(JSON.parse(%("restaurant")))
    JSON.parse(contact.to_json)["vcard"].should eq(JSON.parse(%("BEGIN:VCARD")))
  end
end

describe TelegramBot::WebAppInfo do
  it "parses Web App and Mini App helper objects" do
    web_app = TelegramBot::WebAppInfo.new("https://example.com/app")
    web_app_data = TelegramBot::WebAppData.from_json(<<-JSON)
      {
        "data": "payload",
        "button_text": "Open"
      }
      JSON
    sent_web_app_message = TelegramBot::SentWebAppMessage.from_json(<<-JSON)
      {
        "inline_message_id": "inline-id"
      }
      JSON
    prepared_inline_message = TelegramBot::PreparedInlineMessage.from_json(<<-JSON)
      {
        "id": "prepared-inline-id",
        "expiration_date": 1800000000
      }
      JSON
    prepared_keyboard_button = TelegramBot::PreparedKeyboardButton.from_json(<<-JSON)
      {
        "id": "prepared-keyboard-id"
      }
      JSON
    login_url = TelegramBot::LoginUrl.new(
      "https://example.com/login",
      forward_text: "Login",
      bot_username: "bot",
      request_write_access: true
    )

    JSON.parse(web_app.to_json)["url"].should eq("https://example.com/app")
    web_app_data.data.should eq("payload")
    web_app_data.button_text.should eq("Open")
    sent_web_app_message.inline_message_id.should eq("inline-id")
    prepared_inline_message.expiration_date.should eq(1_800_000_000)
    prepared_keyboard_button.id.should eq("prepared-keyboard-id")
    JSON.parse(login_url.to_json)["request_write_access"].should be_true
  end
end

describe TelegramBot::ChatMember do
  it "parses member and invite link fields" do
    member = TelegramBot::ChatMember.from_json(<<-JSON)
      {
        "status": "restricted",
        "user": {"id": 1, "is_bot": false, "first_name": "User"},
        "is_member": true,
        "can_send_messages": true,
        "can_send_photos": true,
        "can_react_to_messages": true,
        "can_edit_tag": true,
        "tag": "Trusted",
        "until_date": 1800000000
      }
      JSON
    link = TelegramBot::ChatInviteLink.from_json(<<-JSON)
      {
        "invite_link": "https://t.me/+invite",
        "creator": {"id": 2, "is_bot": true, "first_name": "Bot"},
        "creates_join_request": true,
        "is_primary": false,
        "is_revoked": false,
        "subscription_period": 2592000,
        "subscription_price": 100
      }
      JSON
    update = TelegramBot::ChatMemberUpdated.from_json(<<-JSON)
      {
        "chat": {"id": -100, "type": "supergroup", "title": "Group"},
        "from": {"id": 3, "is_bot": false, "first_name": "Admin"},
        "date": 0,
        "old_chat_member": {
          "status": "left",
          "user": {"id": 1, "is_bot": false, "first_name": "User"}
        },
        "new_chat_member": {
          "status": "member",
          "user": {"id": 1, "is_bot": false, "first_name": "User"}
        },
        "invite_link": {
          "invite_link": "https://t.me/+invite",
          "creator": {"id": 2, "is_bot": true, "first_name": "Bot"},
          "creates_join_request": false,
          "is_primary": false,
          "is_revoked": false
        }
      }
      JSON

    member.status.should eq("restricted")
    member.is_member?.should be_true
    member.can_send_photos?.should be_true
    member.can_react_to_messages?.should be_true
    member.tag.should eq("Trusted")
    link.subscription_price.should eq(100)
    update.invite_link.try(&.invite_link).should eq("https://t.me/+invite")

    rights = TelegramBot::ChatAdministratorRights.from_json(<<-JSON)
      {
        "is_anonymous": false,
        "can_manage_chat": true,
        "can_delete_messages": true,
        "can_manage_video_chats": true,
        "can_restrict_members": true,
        "can_promote_members": true,
        "can_change_info": true,
        "can_invite_users": true,
        "can_post_stories": true,
        "can_edit_stories": true,
        "can_delete_stories": true,
        "can_manage_tags": true
      }
      JSON

    rights.can_manage_chat?.should be_true
    rights.can_delete_stories?.should be_true
    rights.can_manage_tags?.should be_true
  end
end

describe TelegramBot::PaidMediaInfo do
  it "parses paid media, live photos, and refunded payments" do
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 1,
        "date": 0,
        "chat": {"id": 1, "type": "private"},
        "live_photo": {
          "file_id": "live-video-id",
          "file_unique_id": "live-video-unique-id",
          "width": 320,
          "height": 240,
          "duration": 3,
          "photo": [
            {"file_id": "photo-id", "file_unique_id": "photo-unique-id", "width": 320, "height": 240}
          ]
        },
        "paid_media": {
          "star_count": 10,
          "paid_media": [
            {"type": "preview", "width": 320, "height": 240, "duration": 3},
            {
              "type": "photo",
              "photo": [
                {"file_id": "photo-id", "file_unique_id": "photo-unique-id", "width": 320, "height": 240}
              ]
            },
            {
              "type": "video",
              "video": {
                "file_id": "video-id",
                "file_unique_id": "video-unique-id",
                "width": 320,
                "height": 240,
                "duration": 3,
                "cover": [
                  {"file_id": "cover-id", "file_unique_id": "cover-unique-id", "width": 320, "height": 240}
                ],
                "start_timestamp": 2,
                "qualities": [
                  {
                    "file_id": "quality-id",
                    "file_unique_id": "quality-unique-id",
                    "width": 1280,
                    "height": 720,
                    "codec": "h264",
                    "file_size": 2147483648
                  }
                ],
                "file_name": "video.mp4"
              }
            },
            {
              "type": "live_photo",
              "live_photo": {
                "file_id": "paid-live-photo-id",
                "file_unique_id": "paid-live-photo-unique-id",
                "width": 320,
                "height": 240,
                "duration": 3,
                "photo": [
                  {"file_id": "paid-live-photo-size-id", "file_unique_id": "paid-live-photo-size-unique-id", "width": 320, "height": 240}
                ]
              }
            }
          ]
        },
        "successful_payment": {
          "currency": "XTR",
          "total_amount": 10,
          "invoice_payload": "invoice-payload",
          "subscription_expiration_date": 1800000000,
          "is_recurring": true,
          "is_first_recurring": true,
          "telegram_payment_charge_id": "telegram-charge-id",
          "provider_payment_charge_id": "provider-charge-id"
        },
        "refunded_payment": {
          "currency": "XTR",
          "total_amount": 10,
          "invoice_payload": "invoice-payload",
          "telegram_payment_charge_id": "telegram-charge-id"
        }
      }
      JSON
    transactions = TelegramBot::StarTransactions.from_json(<<-JSON)
      {
        "transactions": [
          {
            "id": "tx-id",
            "amount": 10,
            "date": 1800000000,
            "source": {
              "type": "user",
              "transaction_type": "paid_media_payment",
              "user": {"id": 1, "is_bot": false, "first_name": "User"},
              "paid_media_payload": "payload",
              "paid_media": [{"type": "preview", "width": 320}]
            }
          }
        ]
      }
      JSON
    purchased = TelegramBot::PaidMediaPurchased.from_json(<<-JSON)
      {
        "from": {"id": 1, "is_bot": false, "first_name": "User"},
        "paid_media_payload": "paid-media-payload"
      }
      JSON

    message.live_photo.try(&.file_id).should eq("live-video-id")
    message.paid_media.try(&.star_count).should eq(10)
    message.paid_media.try(&.paid_media[0]).should be_a(TelegramBot::PaidMediaPreview)
    message.paid_media.try(&.paid_media[1]).should be_a(TelegramBot::PaidMediaPhoto)
    message.paid_media.try(&.paid_media[1].as(TelegramBot::PaidMediaPhoto).photo.first.file_id).should eq("photo-id")
    message.paid_media.try(&.paid_media[2]).should be_a(TelegramBot::PaidMediaVideo)
    message.paid_media.try(&.paid_media[2].as(TelegramBot::PaidMediaVideo).video.file_id).should eq("video-id")
    message.paid_media.try(&.paid_media[2].as(TelegramBot::PaidMediaVideo).video.cover.try(&.first.file_id)).should eq("cover-id")
    message.paid_media.try(&.paid_media[2].as(TelegramBot::PaidMediaVideo).video.start_timestamp).should eq(2)
    message.paid_media.try(&.paid_media[2].as(TelegramBot::PaidMediaVideo).video.qualities.try(&.first.codec)).should eq("h264")
    message.paid_media.try(&.paid_media[2].as(TelegramBot::PaidMediaVideo).video.qualities.try(&.first.file_size)).should eq(2_147_483_648)
    message.paid_media.try(&.paid_media[2].as(TelegramBot::PaidMediaVideo).video.file_name).should eq("video.mp4")
    message.paid_media.try(&.paid_media[3]).should be_a(TelegramBot::PaidMediaLivePhoto)
    message.paid_media.try(&.paid_media[3].as(TelegramBot::PaidMediaLivePhoto).live_photo.file_id).should eq("paid-live-photo-id")
    message.successful_payment.try(&.subscription_expiration_date).should eq(1_800_000_000)
    message.successful_payment.try(&.is_recurring?).should be_true
    message.refunded_payment.try(&.telegram_payment_charge_id).should eq("telegram-charge-id")
    source = transactions.transactions.first.source.as(TelegramBot::TransactionPartnerUser)
    source.paid_media_payload.should eq("payload")
    source.paid_media.try(&.first).should be_a(TelegramBot::PaidMediaPreview)
    purchased.from.first_name.should eq("User")
    purchased.paid_media_payload.should eq("paid-media-payload")
  end
end

describe TelegramBot::Gift do
  it "parses gifts and gift message fields" do
    gifts = TelegramBot::Gifts.from_json(<<-JSON)
      {
        "gifts": [
          {
            "id": "gift-id",
            "sticker": {"file_id": "sticker-id", "file_unique_id": "sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
            "star_count": 100,
            "upgrade_star_count": 25,
            "background": {
              "center_color": 16777215,
              "edge_color": 0,
              "text_color": 255
            }
          }
        ]
      }
      JSON
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 1,
        "date": 0,
        "chat": {"id": 1, "type": "private"},
        "gift": {
          "gift": {
            "id": "gift-id",
            "sticker": {"file_id": "sticker-id", "file_unique_id": "sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
            "star_count": 100
          },
          "owned_gift_id": "owned-gift-id",
          "can_be_upgraded": true,
          "text": "Thanks"
        },
        "unique_gift": {
          "origin": "upgrade",
          "gift": {
            "gift_id": "gift-id",
            "base_name": "Gift",
            "name": "Gift #1",
            "number": 1,
            "model": {
              "name": "Model",
              "sticker": {"file_id": "model-sticker-id", "file_unique_id": "model-sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
              "rarity_per_mille": 100
            },
            "symbol": {
              "name": "Symbol",
              "sticker": {"file_id": "symbol-sticker-id", "file_unique_id": "symbol-sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
              "rarity_per_mille": 100
            },
            "backdrop": {
              "name": "Backdrop",
              "colors": {
                "center_color": 1,
                "edge_color": 2,
                "symbol_color": 3,
                "text_color": 4
              },
              "rarity_per_mille": 100
            }
          }
        },
        "gift_upgrade_sent": {
          "gift": {
            "id": "gift-id",
            "sticker": {"file_id": "sticker-id", "file_unique_id": "sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
            "star_count": 100
          }
        }
      }
      JSON
    transaction = TelegramBot::TransactionPartner.from_json(<<-JSON)
      {
        "type": "user",
        "transaction_type": "gift_purchase",
        "user": {"id": 1, "is_bot": false, "first_name": "User"},
        "gift": {
          "id": "gift-id",
          "sticker": {"file_id": "sticker-id", "file_unique_id": "sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
          "star_count": 100
        }
      }
      JSON
    fragment = TelegramBot::TransactionPartner.from_json(<<-JSON)
      {
        "type": "fragment",
        "withdrawal_state": {
          "type": "succeeded",
          "date": 1800000000,
          "url": "https://fragment.com/tx"
        }
      }
      JSON
    telegram_api = TelegramBot::TransactionPartner.from_json(<<-JSON)
      {
        "type": "telegram_api",
        "request_count": 10
      }
      JSON

    gifts.gifts.first.id.should eq("gift-id")
    gifts.gifts.first.background.try(&.text_color).should eq(255)
    message.gift.try(&.owned_gift_id).should eq("owned-gift-id")
    message.gift.try(&.can_be_upgraded?).should be_true
    message.unique_gift.try(&.gift.name).should eq("Gift #1")
    message.gift_upgrade_sent.try(&.gift.id).should eq("gift-id")
    transaction.should be_a(TelegramBot::TransactionPartnerUser)
    transaction.as(TelegramBot::TransactionPartnerUser).gift.try(&.star_count).should eq(100)
    fragment.should be_a(TelegramBot::TransactionPartnerFragment)
    fragment.as(TelegramBot::TransactionPartnerFragment).withdrawal_state.should be_a(TelegramBot::RevenueWithdrawalStateSucceeded)
    telegram_api.as(TelegramBot::TransactionPartnerTelegramApi).request_count.should eq(10)
  end

  it "parses owned gift variants" do
    regular = TelegramBot::OwnedGiftRegular.from_json(<<-JSON)
      {
        "type": "regular",
        "gift": {
          "id": "gift-id",
          "sticker": {"file_id": "sticker-id", "file_unique_id": "sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
          "star_count": 100
        },
        "owned_gift_id": "owned-gift-id",
        "send_date": 1800000000,
        "can_be_upgraded": true,
        "unique_gift_number": 7
      }
      JSON
    unique = TelegramBot::OwnedGiftUnique.from_json(<<-JSON)
      {
        "type": "unique",
        "gift": {
          "gift_id": "unique-gift-id",
          "base_name": "Gift",
          "name": "Gift #1",
          "number": 1,
          "model": {
            "name": "Model",
            "sticker": {"file_id": "model-sticker-id", "file_unique_id": "model-sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
            "rarity_per_mille": 100
          },
          "symbol": {
            "name": "Symbol",
            "sticker": {"file_id": "symbol-sticker-id", "file_unique_id": "symbol-sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
            "rarity_per_mille": 100
          },
          "backdrop": {
            "name": "Backdrop",
            "colors": {
              "center_color": 1,
              "edge_color": 2,
              "symbol_color": 3,
              "text_color": 4
            },
            "rarity_per_mille": 100
          }
        },
        "owned_gift_id": "owned-unique-gift-id",
        "send_date": 1800000000,
        "can_be_transferred": true,
        "transfer_star_count": 25
      }
      JSON
    owned_gifts = TelegramBot::OwnedGifts.from_json(<<-JSON)
      {
        "total_count": 2,
        "gifts": [
          {
            "type": "regular",
            "gift": {
              "id": "gift-id",
              "sticker": {"file_id": "sticker-id", "file_unique_id": "sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
              "star_count": 100
            },
            "send_date": 1800000000
          },
          {
            "type": "unique",
            "gift": {
              "gift_id": "unique-gift-id",
              "base_name": "Gift",
              "name": "Gift #1",
              "number": 1,
              "model": {
                "name": "Model",
                "sticker": {"file_id": "model-sticker-id", "file_unique_id": "model-sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
                "rarity_per_mille": 100
              },
              "symbol": {
                "name": "Symbol",
                "sticker": {"file_id": "symbol-sticker-id", "file_unique_id": "symbol-sticker-id-unique", "type": "regular", "width": 512, "height": 512, "is_animated": false, "is_video": false},
                "rarity_per_mille": 100
              },
              "backdrop": {
                "name": "Backdrop",
                "colors": {
                  "center_color": 1,
                  "edge_color": 2,
                  "symbol_color": 3,
                  "text_color": 4
                },
                "rarity_per_mille": 100
              }
            },
            "send_date": 1800000000
          }
        ]
      }
      JSON

    regular.type.should eq("regular")
    regular.gift.id.should eq("gift-id")
    regular.can_be_upgraded?.should be_true
    regular.unique_gift_number.should eq(7)
    unique.type.should eq("unique")
    unique.gift.name.should eq("Gift #1")
    unique.can_be_transferred?.should be_true
    unique.transfer_star_count.should eq(25)
    owned_gifts.gifts[0].should be_a(TelegramBot::OwnedGiftRegular)
    owned_gifts.gifts[1].should be_a(TelegramBot::OwnedGiftUnique)
    owned_gifts.gifts[1].as(TelegramBot::OwnedGiftUnique).gift.name.should eq("Gift #1")
  end
end

describe TelegramBot::BusinessConnection do
  it "parses business, guest, and managed bot fields" do
    connection = TelegramBot::BusinessConnection.from_json(<<-JSON)
      {
        "id": "business-id",
        "user": {"id": 1, "is_bot": false, "first_name": "User"},
        "user_chat_id": 100,
        "date": 1800000000,
        "rights": {
          "can_reply": true,
          "can_edit_bio": true,
          "can_change_gift_settings": true
        },
        "is_enabled": true
      }
      JSON
    chat = TelegramBot::Chat.from_json(<<-JSON)
      {
        "id": 1,
        "type": "private",
        "is_forum": true,
        "is_direct_messages": true,
        "business_intro": {
          "title": "Intro",
          "message": "Hello"
        },
        "business_location": {
          "address": "Main Street",
          "location": {"longitude": 1.0, "latitude": 2.0}
        },
        "business_opening_hours": {
          "time_zone_name": "Europe/Kiev",
          "opening_hours": [
            {"opening_minute": 60, "closing_minute": 120}
          ]
        },
        "accepted_gift_types": {
          "unlimited_gifts": true,
          "limited_gifts": true,
          "unique_gifts": true,
          "premium_subscription": true,
          "gifts_from_channels": false
        }
      }
      JSON
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 1,
        "date": 0,
        "chat": {"id": 1, "type": "private"},
        "guest_bot_caller_user": {"id": 2, "is_bot": false, "first_name": "Guest"},
        "guest_bot_caller_chat": {"id": 3, "type": "private", "first_name": "Caller"},
        "guest_query_id": "guest-query-id",
        "managed_bot_created": {
          "bot": {"id": 4, "is_bot": true, "first_name": "Managed"},
          "token": "managed-token"
        }
      }
      JSON
    access_settings = TelegramBot::BotAccessSettings.from_json(<<-JSON)
      {
        "is_access_restricted": true,
        "added_users": [
          {"id": 1, "is_bot": false, "first_name": "User"}
        ]
      }
      JSON
    user = TelegramBot::User.from_json(<<-JSON)
      {
        "id": 1,
        "is_bot": false,
        "first_name": "User",
        "is_premium": true,
        "added_to_attachment_menu": true,
        "can_connect_to_business": true,
        "has_main_web_app": true,
        "has_topics_enabled": true,
        "allows_users_to_create_topics": true,
        "supports_guest_queries": true,
        "can_manage_bots": true
      }
      JSON

    connection.id.should eq("business-id")
    connection.user.first_name.should eq("User")
    connection.user_chat_id.should eq(100)
    connection.date.should eq(1_800_000_000)
    connection.rights.try(&.can_edit_bio?).should be_true
    connection.is_enabled?.should be_true
    chat.business_intro.try(&.title).should eq("Intro")
    chat.is_forum?.should be_true
    chat.is_direct_messages?.should be_true
    chat.business_location.try(&.address).should eq("Main Street")
    chat.business_opening_hours.try(&.opening_hours.first.opening_minute).should eq(60)
    chat.accepted_gift_types.try(&.unique_gifts?).should be_true
    message.guest_query_id.should eq("guest-query-id")
    message.managed_bot_created.try(&.bot.first_name).should eq("Managed")
    message.managed_bot_created.try(&.token).should eq("managed-token")
    access_settings.added_users.try(&.first.first_name).should eq("User")
    user.is_premium?.should be_true
    user.added_to_attachment_menu?.should be_true
    user.can_connect_to_business?.should be_true
    user.has_main_web_app?.should be_true
    user.has_topics_enabled?.should be_true
    user.allows_users_to_create_topics?.should be_true
    user.supports_guest_queries?.should be_true
    user.can_manage_bots?.should be_true
  end
end

describe TelegramBot::ChatFullInfo do
  it "parses full chat profile fields" do
    chat = TelegramBot::ChatFullInfo.from_json(<<-JSON)
      {
        "id": 1,
        "type": "private",
        "first_name": "User",
        "is_forum": true,
        "is_direct_messages": true,
        "direct_messages_topic": {
          "topic_id": 123,
          "user": {"id": 2, "is_bot": false, "first_name": "Topic User"}
        },
        "accent_color_id": 1,
        "max_reaction_count": 3,
        "active_usernames": ["user", "old_user"],
        "birthdate": {"day": 1, "month": 2, "year": 2000},
        "personal_chat": {"id": -100, "type": "channel", "title": "Personal"},
        "parent_chat": {"id": -101, "type": "channel", "title": "Parent"},
        "available_reactions": [{"type": "emoji", "emoji": "👍"}],
        "background_custom_emoji_id": "background-emoji-id",
        "profile_accent_color_id": 2,
        "profile_background_custom_emoji_id": "profile-background-id",
        "emoji_status_custom_emoji_id": "status-emoji-id",
        "emoji_status_expiration_date": 1800000000,
        "bio": "Bio",
        "has_private_forwards": true,
        "has_restricted_voice_and_video_messages": true,
        "join_to_send_messages": true,
        "join_by_request": true,
        "permissions": {"can_send_messages": true},
        "accepted_gift_types": {
          "unlimited_gifts": true,
          "limited_gifts": true,
          "unique_gifts": true,
          "premium_subscription": true,
          "gifts_from_channels": false
        },
        "can_send_paid_media": true,
        "slow_mode_delay": 10,
        "unrestrict_boost_count": 2,
        "message_auto_delete_time": 86400,
        "has_aggressive_anti_spam_enabled": true,
        "has_hidden_members": true,
        "has_protected_content": true,
        "has_visible_history": true,
        "custom_emoji_sticker_set_name": "emoji_set",
        "linked_chat_id": -102,
        "location": {
          "location": {"longitude": 1.0, "latitude": 2.0},
          "address": "Main Street"
        },
        "rating": {"level": 5},
        "first_profile_audio": {"file_id": "audio-id", "file_unique_id": "audio-unique-id", "duration": 1},
        "unique_gift_colors": {
          "model_custom_emoji_id": "model-id",
          "symbol_custom_emoji_id": "symbol-id",
          "light_theme_main_color": 1,
          "light_theme_other_colors": [2],
          "dark_theme_main_color": 3,
          "dark_theme_other_colors": [4]
        },
        "paid_message_star_count": 7
      }
      JSON

    chat.accent_color_id.should eq(1)
    chat.direct_messages_topic.try(&.user.try(&.first_name)).should eq("Topic User")
    chat.max_reaction_count.should eq(3)
    chat.active_usernames.try(&.first).should eq("user")
    chat.birthdate.try(&.year).should eq(2000)
    chat.personal_chat.try(&.title).should eq("Personal")
    chat.parent_chat.try(&.title).should eq("Parent")
    chat.available_reactions.try(&.first.emoji).should eq("👍")
    chat.has_private_forwards?.should be_true
    chat.permissions.try(&.can_send_messages?).should be_true
    chat.location.try(&.address).should eq("Main Street")
    chat.rating.try(&.level).should eq(5)
    chat.first_profile_audio.try(&.file_id).should eq("audio-id")
    chat.unique_gift_colors.try(&.model_custom_emoji_id).should eq("model-id")
    chat.paid_message_star_count.should eq(7)
  end
end

describe TelegramBot::Sticker do
  it "parses sticker set fields and serializes input stickers" do
    sticker_set = TelegramBot::StickerSet.from_json(<<-JSON)
      {
        "name": "set_name",
        "title": "Sticker Set",
        "sticker_type": "custom_emoji",
        "stickers": [{
          "file_id": "sticker-id",
          "file_unique_id": "sticker-unique-id",
          "type": "custom_emoji",
          "width": 512,
          "height": 512,
          "is_animated": true,
          "is_video": false,
          "thumbnail": {"file_id": "thumb-id", "file_unique_id": "thumb-unique-id", "width": 100, "height": 100},
          "emoji": "🙂",
          "set_name": "set_name",
          "premium_animation": {"file_id": "animation-id", "file_unique_id": "animation-unique-id"},
          "mask_position": {"point": "forehead", "x_shift": 0.1, "y_shift": 0.2, "scale": 1.3},
          "custom_emoji_id": "emoji-id",
          "needs_repainting": true,
          "file_size": 1024
        }],
        "thumbnail": {"file_id": "set-thumb-id", "file_unique_id": "set-thumb-unique-id", "width": 100, "height": 100}
      }
      JSON
    input_sticker = TelegramBot::InputSticker.new(
      "attach://sticker",
      "static",
      ["🙂"],
      TelegramBot::MaskPosition.new("forehead", 0.1, 0.2, 1.3),
      ["crystal"]
    )
    input_json = JSON.parse(input_sticker.to_json)

    sticker_set.sticker_type.should eq("custom_emoji")
    sticker_set.thumbnail.try(&.file_id).should eq("set-thumb-id")
    sticker = sticker_set.stickers.first
    sticker.is_animated?.should be_true
    sticker.thumbnail.try(&.file_id).should eq("thumb-id")
    sticker.premium_animation.try(&.file_id).should eq("animation-id")
    sticker.mask_position.try(&.point).should eq("forehead")
    sticker.custom_emoji_id.should eq("emoji-id")
    sticker.needs_repainting?.should be_true
    sticker.file_size.should eq(1024)
    input_json["sticker"].should eq("attach://sticker")
    input_json["keywords"][0].should eq("crystal")
  end
end
