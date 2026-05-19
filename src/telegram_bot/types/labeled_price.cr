module TelegramBot
  class LabeledPrice
    include JSON::Serializable

    property label : String
    property amount : Int64

    def initialize(@label : String, amount : Int)
      @amount = amount.to_i64
    end
  end
end
