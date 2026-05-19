module TelegramBot
  class Invoice
    include JSON::Serializable

    property title : String
    property description : String
    property start_parameter : String
    property currency : String
    property total_amount : Int64
  end
end
