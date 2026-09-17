module TelegramBot
  class WebhookInfo
    include JSON::Serializable

    property url : String
    property? has_custom_certificate : Bool
    property pending_update_count : Int32
    property ip_address : String?
    property last_error_date : Int32?
    property last_error_message : String?
    property last_synchronization_error_date : Int32?
    property max_connections : Int32?
    property allowed_updates : Array(String)?
  end
end
