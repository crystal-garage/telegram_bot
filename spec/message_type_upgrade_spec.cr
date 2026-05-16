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
    message.has_protected_content?.should be_true
    message.is_from_offline?.should be_true
    message.is_paid_post?.should be_true
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
    message.web_app_data.try(&.button_text).should eq("Finish")
    message.reply_markup.try(&.inline_keyboard.first.first.text).should eq("Open")
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
