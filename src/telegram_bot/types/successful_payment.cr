module TelegramBot
  class SuccessfulPayment
    include JSON::Serializable

    property currency : String
    property total_amount : Int64
    property invoice_payload : String
    property subscription_expiration_date : Int32?
    property? is_recurring : Bool?
    property? is_first_recurring : Bool?
    property shipping_option_id : String?
    property order_info : OrderInfo?
    property telegram_payment_charge_id : String
    property provider_payment_charge_id : String
  end
end
