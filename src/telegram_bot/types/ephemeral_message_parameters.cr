module TelegramBot
  class EphemeralMessageParameters
    include JSON::Serializable

    property receiver_user_id : Int64
    property callback_query_id : String?
    property? replace_callback_query_message : Bool?

    def initialize(
      @receiver_user_id : Int64,
      *,
      @callback_query_id : String? = nil,
      @replace_callback_query_message : Bool? = nil,
    )
    end
  end
end
