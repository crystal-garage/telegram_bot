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
