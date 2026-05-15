require "./spec_helper"

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
          "option_persistent_id": "added-option-id",
          "option_text": "Added"
        },
        "poll_option_deleted": {
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
    message.poll_option_deleted.try(&.option_persistent_id).should eq("deleted-option-id")
  end
end

describe TelegramBot::InputPollOption do
  it "serializes poll option input" do
    option = TelegramBot::InputPollOption.new(
      "Option",
      text_entities: [TelegramBot::MessageEntity.new("custom_emoji", 0, 2, custom_emoji_id: "emoji-id")]
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
        ]
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

    update.old_reaction.try(&.first.emoji).should eq("👍")
    update.new_reaction.try(&.first.custom_emoji_id).should eq("emoji-id")
    count.type.try(&.type).should eq("paid")
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

describe TelegramBot::ChatMember do
  it "parses modern member and invite link fields" do
    member = TelegramBot::ChatMember.from_json(<<-JSON)
      {
        "status": "restricted",
        "user": {"id": 1, "is_bot": false, "first_name": "User"},
        "is_member": true,
        "can_send_messages": true,
        "can_send_photos": true,
        "can_react_to_messages": true,
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
    link.subscription_price.should eq(100)
    update.invite_link.try(&.invite_link).should eq("https://t.me/+invite")
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

    message.live_photo.try(&.file_id).should eq("live-video-id")
    message.paid_media.try(&.star_count).should eq(10)
    message.paid_media.try(&.paid_media.first.type).should eq("preview")
    message.paid_media.try(&.paid_media.last.photo.try(&.first.file_id)).should eq("photo-id")
    message.successful_payment.try(&.subscription_expiration_date).should eq(1_800_000_000)
    message.successful_payment.try(&.is_recurring?).should be_true
    message.refunded_payment.try(&.telegram_payment_charge_id).should eq("telegram-charge-id")
    transactions.transactions.first.source.try(&.paid_media_payload).should eq("payload")
    transactions.transactions.first.source.try(&.paid_media.try(&.first.type)).should eq("preview")
  end
end

describe TelegramBot::Gift do
  it "parses gifts and gift message fields" do
    gifts = TelegramBot::Gifts.from_json(<<-JSON)
      {
        "gifts": [
          {
            "id": "gift-id",
            "sticker": {"file_id": "sticker-id", "width": 512, "height": 512},
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
            "sticker": {"file_id": "sticker-id", "width": 512, "height": 512},
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
              "sticker": {"file_id": "model-sticker-id", "width": 512, "height": 512},
              "rarity_per_mille": 100
            },
            "symbol": {
              "name": "Symbol",
              "sticker": {"file_id": "symbol-sticker-id", "width": 512, "height": 512},
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
            "sticker": {"file_id": "sticker-id", "width": 512, "height": 512},
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
          "sticker": {"file_id": "sticker-id", "width": 512, "height": 512},
          "star_count": 100
        }
      }
      JSON

    gifts.gifts.first.id.should eq("gift-id")
    gifts.gifts.first.background.try(&.text_color).should eq(255)
    message.gift.try(&.owned_gift_id).should eq("owned-gift-id")
    message.gift.try(&.can_be_upgraded?).should be_true
    message.unique_gift.try(&.gift.name).should eq("Gift #1")
    message.gift_upgrade_sent.try(&.gift.id).should eq("gift-id")
    transaction.gift.try(&.star_count).should eq(100)
  end
end
