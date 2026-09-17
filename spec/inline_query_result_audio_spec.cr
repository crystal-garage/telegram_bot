require "./spec_helper"

describe TelegramBot::InlineQueryResultAudio do
  it "it's type is \"audio\"" do
    inline_query_result_audio = TelegramBot::InlineQueryResultAudio.new("", "", "", audio_duration: 45)

    inline_query_result_audio.type.should eq("audio")
    inline_query_result_audio.title.should eq("")
    inline_query_result_audio.audio_duration.should eq(45)
  end
end
