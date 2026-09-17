module TelegramBot
  class BotSubscriptionUpdated
    include JSON::Serializable

    property user : User
    property invoice_payload : String
    property state : String

    def initialize(
      @user : User,
      @invoice_payload : String,
      @state : String,
    )
    end
  end
end
