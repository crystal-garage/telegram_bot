module TelegramBot
  class ShippingQuery
    include JSON::Serializable

    property id : String
    property from : User
    property invoice_payload : String
    property shipping_address : ShippingAddress
  end
end
