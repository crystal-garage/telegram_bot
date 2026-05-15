module TelegramBot
  class PaidMediaPurchased
    include JSON::Serializable

    property from : User?
    property paid_media_payload : String?
  end
end
