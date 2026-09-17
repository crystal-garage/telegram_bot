module TelegramBot
  class APIException < Exception
    @data : JSON::Any?
    @code : Int32

    getter code, data

    def initialize(@code, @data)
    end

    def message
      "Error #{@code} in call to Telegram API : #{@data}"
    end

    def description : String?
      @data.try &.["description"]?.try &.as_s?
    end

    def parameters : ResponseParameters?
      @data.try do |data|
        data["parameters"]?.try { |parameters| ResponseParameters.from_json(parameters.to_json) }
      end
    end
  end
end
