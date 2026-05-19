module TelegramBot
  class ShippingOption
    include JSON::Serializable

    property id : String
    property title : String
    property prices : Array(LabeledPrice)
  end
end
