module TelegramBot
  class SuggestedPostPrice
    include JSON::Serializable

    property currency : String
    property amount : Int64

    def initialize(@currency : String, @amount : Int64)
    end
  end

  class SuggestedPostParameters
    include JSON::Serializable

    property price : SuggestedPostPrice?
    property send_date : Int32?

    def initialize(
      *,
      @price = nil,
      @send_date = nil,
    )
    end
  end
end
