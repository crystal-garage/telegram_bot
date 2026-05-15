module TelegramBot
  class InputMedia
    def to_json(json : JSON::Builder)
      raise "InputMedia subclasses must implement JSON serialization"
    end
  end
end
