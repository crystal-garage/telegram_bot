require "./spec_helper"

describe TelegramBot::ReplyKeyboardMarkup do
  it "can be built with KeyboardButton objects" do
    buttons = [[
      TelegramBot::KeyboardButton.new("Button 1", request_contact: false, request_location: true),
      TelegramBot::KeyboardButton.new("Button 2", request_contact: true, request_location: false),
    ]]

    markup_json = TelegramBot::ReplyKeyboardMarkup.new(buttons).to_json

    JSON.parse(markup_json).should eq({"keyboard" => [
      [
        {"text" => "Button 1", "request_contact" => false, "request_location" => true},
        {"text" => "Button 2", "request_contact" => true, "request_location" => false},
      ],
    ]})
  end

  it "can be built with text only if other flags are unnecesary" do
    buttons = [["Button 1", "Button 2"]]

    markup_json = TelegramBot::ReplyKeyboardMarkup.new(buttons).to_json
    JSON.parse(markup_json).should eq({"keyboard" => [[{"text" => "Button 1"}, {"text" => "Button 2"}]]})
  end
end

describe TelegramBot::InlineKeyboardMarkup do
  it "serializes disabled buttons and force-reply keyboards" do
    button = TelegramBot::InlineKeyboardButton.new("Unavailable", disabled: TelegramBot::DisabledButton.new)
    JSON.parse(button.to_json)["disabled"].should eq(JSON.parse("{}"))
    markup = TelegramBot::InlineKeyboardMarkup.new([[button]], force_reply: true)
    JSON.parse(markup.to_json)["force_reply"].as_bool.should be_true
    TelegramBot::InlineKeyboardMarkup.new([button], force_reply: false).force_reply?.should be_false
    keyboard = TelegramBot::ReplyKeyboardMarkup.new([["Reply"]], force_reply: true)
    JSON.parse(keyboard.to_json)["force_reply"].as_bool.should be_true
  end
end
