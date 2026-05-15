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
    when "answerInlineQuery", "answerShippingQuery", "answerPreCheckoutQuery", "pinChatMessage", "unpinChatMessage", "setMyCommands"
      JSON.parse("true")
    else
      JSON.parse(%({"message_id":1,"date":0,"chat":{"id":1,"type":"private"}}))
    end
  end

  def serialize_for_spec(params : Hash)
    serialize_params(params)
  end

  def handle(shipping_query : TelegramBot::ShippingQuery)
    @handled_update = shipping_query.id
  end

  def handle(pre_checkout_query : TelegramBot::PreCheckoutQuery)
    @handled_update = pre_checkout_query.id
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
end
