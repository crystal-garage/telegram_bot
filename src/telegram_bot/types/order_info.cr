module TelegramBot
  class OrderInfo
    include JSON::Serializable

    property name : String?
    property phone_number : String?
    property email : String?
    property shipping_address : ShippingAddress?
  end
end
