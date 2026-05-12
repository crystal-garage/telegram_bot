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
    when "answerShippingQuery", "answerPreCheckoutQuery", "pinChatMessage", "unpinChatMessage"
      JSON.parse("true")
    else
      JSON.parse(%({"message_id":1,"date":0,"chat":{"id":1,"type":"private"}}))
    end
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
