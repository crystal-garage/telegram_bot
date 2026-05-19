module TelegramBot
  class InaccessibleMessage
    include JSON::Serializable

    property chat : Chat
    property message_id : Int32
    property date : Int32
  end

  alias MaybeInaccessibleMessage = Message | InaccessibleMessage
end
