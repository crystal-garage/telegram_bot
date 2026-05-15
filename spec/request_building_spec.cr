require "./spec_helper"

class RequestBuildingBot < TelegramBot::Bot
  getter last_method, last_force_http, last_params, handled_update

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

    case method
    when "answerInlineQuery", "answerShippingQuery", "answerPreCheckoutQuery", "pinChatMessage", "unpinChatMessage", "sendMessageDraft", "setMyCommands"
      JSON.parse("true")
    when "copyMessage"
      JSON.parse(%({"message_id":100}))
    when "copyMessages", "forwardMessages"
      JSON.parse(%([{"message_id":100},{"message_id":101}]))
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
