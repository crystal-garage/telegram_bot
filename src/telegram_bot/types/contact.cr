module TelegramBot
  class Contact
    include JSON::Serializable

    property phone_number : String
    property first_name : String
    property last_name : String?
    property user_id : Int64?
    property vcard : String?
  end
end
