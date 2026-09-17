module TelegramBot
  abstract class InlineQueryResult
    def to_json(json : JSON::Builder)
      raise "InlineQueryResult subclasses must implement JSON serialization"
    end
  end
end
