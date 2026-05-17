require "./spec_helper"

describe TelegramBot::Message do
  it "parses core message fields" do
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 42,
        "message_thread_id": 7,
        "direct_messages_topic": {"topic_id": 3},
        "from": {"id": 1, "is_bot": false, "first_name": "Sender"},
        "sender_chat": {"id": -100, "type": "supergroup", "title": "Group"},
        "sender_boost_count": 2,
        "sender_business_bot": {"id": 2, "is_bot": true, "first_name": "Business Bot"},
        "date": 0,
        "business_connection_id": "business-id",
        "chat": {"id": 1, "type": "private"},
        "forward_origin": {
          "type": "user",
          "date": 0,
          "sender_user": {"id": 3, "is_bot": false, "first_name": "Original"}
        },
        "is_topic_message": true,
        "is_automatic_forward": true,
        "external_reply": {
          "origin": {"type": "hidden_user", "date": 0, "sender_user_name": "Hidden"},
          "message_id": 10,
          "link_preview_options": {"url": "https://example.com"}
        },
        "quote": {
          "text": "quoted",
          "position": 0,
          "entities": [{"type": "bold", "offset": 0, "length": 6}],
          "is_manual": true
        },
        "reply_to_story": {
          "chat": {"id": 1, "type": "private"},
          "id": 99
        },
        "reply_to_checklist_task_id": 5,
        "reply_to_poll_option_id": "option-id",
        "has_protected_content": true,
        "is_from_offline": true,
        "is_paid_post": true,
        "suggested_post_info": {
          "state": "pending",
          "price": {"currency": "XTR", "amount": 100},
          "send_date": 1800000000
        },
        "paid_star_count": 15,
        "text": "hello",
        "link_preview_options": {"is_disabled": false, "show_above_text": true},
        "effect_id": "effect-id",
        "show_caption_above_media": true,
        "has_media_spoiler": true,
        "checklist": {
          "title": "Launch",
          "tasks": [
            {
              "id": 1,
              "text": "Ship",
              "completed_by_user": {"id": 4, "is_bot": false, "first_name": "Worker"},
              "completion_date": 1800000000
            }
          ],
          "others_can_add_tasks": true,
          "others_can_mark_tasks_as_done": true
        },
        "checklist_tasks_done": {
          "marked_as_done_task_ids": [1],
          "marked_as_not_done_task_ids": [2]
        },
        "checklist_tasks_added": {
          "tasks": [{"id": 3, "text": "Document"}]
        },
        "direct_message_price_changed": {
          "are_direct_messages_enabled": true,
          "direct_message_star_count": 5
        },
        "paid_message_price_changed": {
          "paid_message_star_count": 10
        },
        "chat_owner_left": {
          "new_owner": {"id": 20, "is_bot": false, "first_name": "Next Owner"}
        },
        "chat_owner_changed": {
          "new_owner": {"id": 21, "is_bot": false, "first_name": "Owner"}
        },
        "story": {
          "chat": {"id": 1, "type": "private"},
          "id": 100
        },
        "web_app_data": {"data": "action=done", "button_text": "Finish"},
        "reply_markup": {"inline_keyboard": [[{"text": "Open", "url": "https://example.com"}]]}
      }
      JSON

    message.message_thread_id.should eq(7)
    message.direct_messages_topic.try(&.topic_id).should eq(3)
    message.sender_chat.try(&.title).should eq("Group")
    message.sender_boost_count.should eq(2)
    message.sender_business_bot.try(&.first_name).should eq("Business Bot")
    message.business_connection_id.should eq("business-id")
    message.forward_origin.try(&.type).should eq("user")
    message.is_topic_message?.should be_true
    message.is_automatic_forward?.should be_true
    message.external_reply.try(&.origin.type).should eq("hidden_user")
    message.external_reply.try(&.link_preview_options.try(&.url)).should eq("https://example.com")
    message.quote.try(&.text).should eq("quoted")
    message.quote.try(&.is_manual?).should be_true
    message.reply_to_story.try(&.id).should eq(99)
    message.reply_to_checklist_task_id.should eq(5)
    message.reply_to_poll_option_id.should eq("option-id")
    message.chat_owner_left.try(&.new_owner.try(&.first_name)).should eq("Next Owner")
    message.chat_owner_changed.try(&.new_owner.first_name).should eq("Owner")
    message.has_protected_content?.should be_true
    message.is_from_offline?.should be_true
    message.is_paid_post?.should be_true
    message.suggested_post_info.try(&.state).should eq("pending")
    message.paid_star_count.should eq(15)
    message.link_preview_options.try(&.show_above_text?).should be_true
    message.effect_id.should eq("effect-id")
    message.show_caption_above_media?.should be_true
    message.has_media_spoiler?.should be_true
    message.checklist.try(&.title).should eq("Launch")
    message.checklist.try(&.tasks.first.completed_by_user.try(&.first_name)).should eq("Worker")
    message.checklist.try(&.others_can_add_tasks?).should be_true
    message.checklist_tasks_done.try(&.marked_as_done_task_ids).should eq([1])
    message.checklist_tasks_added.try(&.tasks.first.text).should eq("Document")
    message.direct_message_price_changed.try(&.are_direct_messages_enabled?).should be_true
    message.direct_message_price_changed.try(&.direct_message_star_count).should eq(5)
    message.paid_message_price_changed.try(&.paid_message_star_count).should eq(10)
    message.story.try(&.id).should eq(100)
    message.web_app_data.try(&.button_text).should eq("Finish")
    message.reply_markup.try(&.inline_keyboard.first.first.text).should eq("Open")
  end

  it "parses common chat service message payloads" do
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 44,
        "date": 0,
        "chat": {"id": 1, "type": "private"},
        "message_auto_delete_timer_changed": {
          "message_auto_delete_time": 86400
        },
        "users_shared": {
          "request_id": 1,
          "users": [
            {
              "user_id": 10,
              "first_name": "Shared",
              "username": "shared_user",
              "photo": [
                {"file_id": "photo-id", "file_unique_id": "photo-unique-id", "width": 32, "height": 32}
              ]
            }
          ]
        },
        "chat_shared": {
          "request_id": 2,
          "chat_id": -100,
          "title": "Shared Chat",
          "username": "shared_chat"
        },
        "connected_website": "example.com",
        "write_access_allowed": {
          "from_request": true,
          "web_app_name": "App",
          "from_attachment_menu": true
        },
        "proximity_alert_triggered": {
          "traveler": {"id": 11, "is_bot": false, "first_name": "Traveler"},
          "watcher": {"id": 12, "is_bot": false, "first_name": "Watcher"},
          "distance": 50
        },
        "boost_added": {
          "boost_count": 2
        },
        "chat_background_set": {
          "type": {
            "type": "pattern",
            "document": {
              "file_id": "pattern-id",
              "file_name": "pattern.tgv"
            },
            "fill": {
              "type": "gradient",
              "top_color": 16777215,
              "bottom_color": 0,
              "rotation_angle": 45
            },
            "intensity": 50,
            "is_inverted": true,
            "is_moving": true
          }
        }
      }
      JSON

    message.message_auto_delete_timer_changed.try(&.message_auto_delete_time).should eq(86400)
    message.users_shared.try(&.users.first.username).should eq("shared_user")
    message.users_shared.try(&.users.first.photo.try(&.first.file_id)).should eq("photo-id")
    message.chat_shared.try(&.chat_id).should eq(-100)
    message.connected_website.should eq("example.com")
    message.write_access_allowed.try(&.from_request?).should be_true
    message.write_access_allowed.try(&.web_app_name).should eq("App")
    message.proximity_alert_triggered.try(&.distance).should eq(50)
    message.boost_added.try(&.boost_count).should eq(2)
    message.chat_background_set.try(&.type.type).should eq("pattern")
    message.chat_background_set.try(&.type.fill.try(&.top_color)).should eq(16_777_215)
    message.chat_background_set.try(&.type.document.try(&.file_id)).should eq("pattern-id")
  end

  it "parses video chat service message payloads" do
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 46,
        "date": 0,
        "chat": {"id": 1, "type": "private"},
        "video_chat_scheduled": {
          "start_date": 1800000000
        },
        "video_chat_started": {},
        "video_chat_ended": {
          "duration": 3600
        },
        "video_chat_participants_invited": {
          "users": [{"id": 2, "is_bot": false, "first_name": "Invited"}]
        }
      }
      JSON

    message.video_chat_scheduled.try(&.start_date).should eq(1_800_000_000)
    message.video_chat_started.should be_a(TelegramBot::VideoChatStarted)
    message.video_chat_ended.try(&.duration).should eq(3600)
    message.video_chat_participants_invited.try(&.users.first.first_name).should eq("Invited")
  end

  it "parses passport data" do
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 47,
        "date": 0,
        "chat": {"id": 1, "type": "private"},
        "passport_data": {
          "data": [
            {
              "type": "passport",
              "data": "encrypted-data",
              "front_side": {
                "file_id": "front-file-id",
                "file_unique_id": "front-file-unique-id",
                "file_size": 1024,
                "file_date": 1800000000
              },
              "translation": [
                {
                  "file_id": "translation-file-id",
                  "file_unique_id": "translation-file-unique-id",
                  "file_size": 2048,
                  "file_date": 1800000001
                }
              ],
              "hash": "element-hash"
            },
            {
              "type": "email",
              "email": "user@example.com",
              "hash": "email-hash"
            }
          ],
          "credentials": {
            "data": "credentials-data",
            "hash": "credentials-hash",
            "secret": "credentials-secret"
          }
        }
      }
      JSON

    passport_data = message.passport_data.not_nil!
    passport_data.data.first.type.should eq("passport")
    passport_data.data.first.front_side.try(&.file_id).should eq("front-file-id")
    passport_data.data.first.translation.try(&.first.file_unique_id).should eq("translation-file-unique-id")
    passport_data.data.last.email.should eq("user@example.com")
    passport_data.credentials.secret.should eq("credentials-secret")
  end

  it "parses giveaway message payloads" do
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 45,
        "date": 0,
        "chat": {"id": 1, "type": "private"},
        "giveaway_created": {
          "prize_star_count": 100
        },
        "giveaway": {
          "chats": [{"id": -100, "type": "channel", "title": "Channel"}],
          "winners_selection_date": 1800000000,
          "winner_count": 2,
          "only_new_members": true,
          "has_public_winners": true,
          "prize_description": "Prize",
          "country_codes": ["UA", "US"],
          "prize_star_count": 100
        },
        "giveaway_winners": {
          "chat": {"id": -100, "type": "channel", "title": "Channel"},
          "giveaway_message_id": 10,
          "winners_selection_date": 1800000000,
          "winner_count": 1,
          "winners": [{"id": 2, "is_bot": false, "first_name": "Winner"}],
          "unclaimed_prize_count": 1,
          "was_refunded": true
        },
        "giveaway_completed": {
          "winner_count": 2,
          "unclaimed_prize_count": 1,
          "is_star_giveaway": true
        },
        "external_reply": {
          "origin": {"type": "user", "date": 0, "sender_user": {"id": 3, "is_bot": false, "first_name": "Sender"}},
          "story": {
            "chat": {"id": 1, "type": "private"},
            "id": 101
          },
          "checklist": {
            "title": "Reply checklist",
            "tasks": [{"id": 1, "text": "Task"}]
          },
          "giveaway": {
            "chats": [{"id": -100, "type": "channel", "title": "Channel"}],
            "winners_selection_date": 1800000000,
            "winner_count": 2
          },
          "giveaway_winners": {
            "chat": {"id": -100, "type": "channel", "title": "Channel"},
            "giveaway_message_id": 10,
            "winners_selection_date": 1800000000,
            "winner_count": 1,
            "winners": [{"id": 2, "is_bot": false, "first_name": "Winner"}]
          }
        }
      }
      JSON

    message.giveaway_created.try(&.prize_star_count).should eq(100)
    message.giveaway.try(&.winner_count).should eq(2)
    message.giveaway.try(&.country_codes.try(&.first)).should eq("UA")
    message.giveaway_winners.try(&.winners.first.first_name).should eq("Winner")
    message.giveaway_winners.try(&.was_refunded?).should be_true
    message.giveaway_completed.try(&.is_star_giveaway?).should be_true
    message.external_reply.try(&.story.try(&.id)).should eq(101)
    message.external_reply.try(&.checklist.try(&.title)).should eq("Reply checklist")
    message.external_reply.try(&.giveaway.try(&.winner_count)).should eq(2)
    message.external_reply.try(&.giveaway_winners.try(&.winner_count)).should eq(1)
  end

  it "parses suggested post service messages" do
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 43,
        "date": 0,
        "chat": {"id": 1, "type": "private"},
        "suggested_post_approved": {
          "suggested_post_message": {
            "message_id": 40,
            "date": 0,
            "chat": {"id": 1, "type": "private"},
            "text": "Suggested"
          },
          "price": {"currency": "XTR", "amount": 100},
          "send_date": 1800000000
        },
        "suggested_post_approval_failed": {
          "price": {"currency": "XTR", "amount": 100}
        },
        "suggested_post_declined": {
          "comment": "Needs edits"
        },
        "suggested_post_paid": {
          "currency": "XTR",
          "star_amount": {"amount": 100}
        },
        "suggested_post_refunded": {
          "reason": "post_deleted"
        }
      }
      JSON

    message.suggested_post_approved.try(&.send_date).should eq(1_800_000_000)
    message.suggested_post_approved.try(&.suggested_post_message.try(&.text)).should eq("Suggested")
    message.suggested_post_approval_failed.try(&.price.currency).should eq("XTR")
    message.suggested_post_declined.try(&.comment).should eq("Needs edits")
    message.suggested_post_paid.try(&.star_amount.try(&.amount)).should eq(100)
    message.suggested_post_refunded.try(&.reason).should eq("post_deleted")
  end
end

describe TelegramBot::InputChecklist do
  it "serializes checklist request objects" do
    checklist = TelegramBot::InputChecklist.new(
      "Launch",
      [
        TelegramBot::InputChecklistTask.new(
          1,
          "Ship",
          text_entities: [TelegramBot::MessageEntity.new("bold", 0, 4)]
        ),
      ],
      parse_mode: "MarkdownV2",
      others_can_add_tasks: true
    )

    JSON.parse(checklist.to_json).should eq(JSON.parse(<<-JSON))
      {
        "title": "Launch",
        "parse_mode": "MarkdownV2",
        "tasks": [
          {
            "id": 1,
            "text": "Ship",
            "text_entities": [{"type": "bold", "offset": 0, "length": 4}]
          }
        ],
        "others_can_add_tasks": true
      }
      JSON
  end
end

describe TelegramBot::MessageEntity do
  it "parses entity fields" do
    custom_emoji = TelegramBot::MessageEntity.from_json(<<-JSON)
      {
        "type": "custom_emoji",
        "offset": 0,
        "length": 2,
        "custom_emoji_id": "custom-emoji-id"
      }
      JSON
    date_time = TelegramBot::MessageEntity.from_json(<<-JSON)
      {
        "type": "date_time",
        "offset": 0,
        "length": 5,
        "unix_time": 1770000000,
        "date_time_format": "date"
      }
      JSON

    custom_emoji.custom_emoji_id.should eq("custom-emoji-id")
    date_time.unix_time.should eq(1770000000)
    date_time.date_time_format.should eq("date")
  end
end

describe TelegramBot::ReplyParameters do
  it "serializes reply and link preview options" do
    reply_parameters = TelegramBot::ReplyParameters.new(
      42,
      chat_id: "@channel",
      allow_sending_without_reply: true,
      quote: "quoted",
      quote_entities: [TelegramBot::MessageEntity.new("bold", 0, 6)],
      quote_position: 0,
      checklist_task_id: 1,
      poll_option_id: "option-id"
    )
    link_preview_options = TelegramBot::LinkPreviewOptions.new(
      is_disabled: false,
      url: "https://example.com",
      prefer_small_media: true,
      show_above_text: true
    )

    JSON.parse(reply_parameters.to_json).should eq(JSON.parse(<<-JSON))
      {
        "message_id": 42,
        "chat_id": "@channel",
        "allow_sending_without_reply": true,
        "quote": "quoted",
        "quote_entities": [{"type": "bold", "offset": 0, "length": 6}],
        "quote_position": 0,
        "checklist_task_id": 1,
        "poll_option_id": "option-id"
      }
      JSON
    JSON.parse(link_preview_options.to_json).should eq(JSON.parse(<<-JSON))
      {
        "is_disabled": false,
        "url": "https://example.com",
        "prefer_small_media": true,
        "show_above_text": true
      }
      JSON
  end
end

describe TelegramBot::MessageOriginUser do
  it "parses concrete message origin types" do
    origin = TelegramBot::MessageOriginUser.from_json(<<-JSON)
      {
        "type": "user",
        "date": 0,
        "sender_user": {"id": 1, "is_bot": false, "first_name": "User"}
      }
      JSON

    origin.type.should eq("user")
    origin.sender_user.first_name.should eq("User")
  end
end
