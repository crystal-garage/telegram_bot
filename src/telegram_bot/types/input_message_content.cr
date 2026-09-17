module TelegramBot
  abstract class InputMessageContent
    def to_json(json : JSON::Builder)
      raise "InputMessageContent subclasses must implement JSON serialization"
    end
  end
end
