module TelegramBot
  class PreCheckoutQuery
    include JSON::Serializable

    property id : String
    property from : User
    property currency : String
    property total_amount : Int64
    property invoice_payload : String
    property shipping_option_id : String?
    property order_info : OrderInfo?
  end
end
