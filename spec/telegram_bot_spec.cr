require "./spec_helper"

class TestBot < TelegramBot::Bot
  include TelegramBot::CmdHandler

  def initialize
    super "testbot", ""

    cmd "example" do |msg, _params|
      send_message msg.chat.id, "test"
    end
  end

  protected def request(method : String, force_http : Bool = false, params = nil)
    Fiber.yield
    JSON.parse("[]")
  end
end

class OverrideHandlerBot < TelegramBot::Bot
  getter handled_message : String?

  def initialize
    super "overridebot", ""
    @handled_message = nil.as(String?)
  end

  def handle(message : TelegramBot::Message)
    @handled_message = message.text
  end
end

describe TelegramBot do
  it "works" do
    TestBot.new
  end

  it "logs messages" do
    io = IO::Memory.new
    test = TestBot.new
    TestBot::Log.level = :debug
    TestBot::Log.backend = ::Log::IOBackend.new(io)

    spawn { test.polling }
    Fiber.yield
    test.stop
    Fiber.yield

    logs = io.to_s
    logs.should match(/TestBot is ready to lead/)
    logs.should match(/TestBot is going to take a rest/)
  end

  it "dispatches messages to registered block handlers" do
    bot = TelegramBot::Bot.new("blockbot", "")
    handled_message = nil.as(String?)

    bot.on_message do |message|
      handled_message = message.text
    end

    bot.handle_update(TelegramBot::Update.from_json(<<-JSON))
      {
        "update_id": 1,
        "message": {
          "message_id": 10,
          "date": 0,
          "chat": {"id": 1, "type": "private"},
          "from": {"id": 1, "is_bot": false, "first_name": "User", "username": "allowed"},
          "text": "hello"
        }
      }
      JSON

    handled_message.should eq("hello")
  end

  it "keeps subclass handlers authoritative over registered block handlers" do
    bot = OverrideHandlerBot.new
    block_called = false

    bot.on_message do |_message|
      block_called = true
    end

    bot.handle_update(TelegramBot::Update.from_json(<<-JSON))
      {
        "update_id": 1,
        "message": {
          "message_id": 10,
          "date": 0,
          "chat": {"id": 1, "type": "private"},
          "text": "override"
        }
      }
      JSON

    bot.handled_message.should eq("override")
    block_called.should be_false
  end

  it "applies allowlist filtering before registered block handlers" do
    bot = TelegramBot::Bot.new("blockbot", "", allowlist: ["allowed"])
    block_called = false

    bot.on_message do |_message|
      block_called = true
    end

    bot.handle_update(TelegramBot::Update.from_json(<<-JSON))
      {
        "update_id": 1,
        "message": {
          "message_id": 10,
          "date": 0,
          "chat": {"id": 1, "type": "private"},
          "from": {"id": 1, "is_bot": false, "first_name": "User", "username": "blocked"},
          "text": "hello"
        }
      }
      JSON

    block_called.should be_false
  end

  it "applies blocklist filtering before registered block handlers" do
    bot = TelegramBot::Bot.new("blockbot", "", blocklist: ["blocked"])
    block_called = false

    bot.on_message do |_message|
      block_called = true
    end

    bot.handle_update(TelegramBot::Update.from_json(<<-JSON))
      {
        "update_id": 1,
        "message": {
          "message_id": 10,
          "date": 0,
          "chat": {"id": 1, "type": "private"},
          "from": {"id": 1, "is_bot": false, "first_name": "User", "username": "blocked"},
          "text": "hello"
        }
      }
      JSON

    block_called.should be_false
  end

  it "allows concrete bots without subclassing" do
    TelegramBot::Bot.new("blockbot", "")
  end

  it "preserves default handler errors when no block handler is registered" do
    bot = TelegramBot::Bot.new("blockbot", "")
    message = TelegramBot::Message.from_json(<<-JSON)
      {
        "message_id": 10,
        "date": 0,
        "chat": {"id": 1, "type": "private"},
        "text": "hello"
      }
      JSON

    expect_raises(Exception, "message handler is not implemented") do
      bot.handle(message)
    end
  end
end
