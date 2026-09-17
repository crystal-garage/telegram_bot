module TelegramBot
  class InlineQueryResultsButton
    include JSON::Serializable

    property text : String
    property web_app : WebAppInfo?
    property start_parameter : String?

    def initialize(
      @text : String,
      *,
      @web_app : WebAppInfo? = nil,
      @start_parameter : String? = nil,
    )
    end
  end
end
