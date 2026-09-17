module TelegramBot
  class ShippingAddress
    include JSON::Serializable

    property country_code : String
    property state : String
    property city : String
    property street_line1 : String
    property street_line2 : String
    property post_code : String
  end
end
