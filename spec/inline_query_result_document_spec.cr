require "./spec_helper"

describe TelegramBot::InlineQueryResultDocument do
  it "it's type is \"document\"" do
    inline_query_result_audio = TelegramBot::InlineQueryResultDocument.new("", "", document_url: "", mime_type: "text")

    inline_query_result_audio.type.should eq("document")
    inline_query_result_audio.mime_type.should eq("text")
  end
end
