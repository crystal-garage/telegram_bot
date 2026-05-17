module TelegramBot
  class Chat
    include JSON::Serializable

    property id : Int64
    property type : String
    property title : String?
    property username : String?
    property first_name : String?
    property last_name : String?
    property? is_forum : Bool?
    property? is_direct_messages : Bool?
    property? all_members_are_administrators : Bool?
    property photo : ChatPhoto?
    property business_intro : BusinessIntro?
    property business_location : BusinessLocation?
    property business_opening_hours : BusinessOpeningHours?
    property description : String?
    property invite_link : String?
    property pinned_message : Message?
    property sticker_set_name : String?
    property accepted_gift_types : AcceptedGiftTypes?
    property? can_set_sticker_set : Bool?
    property? can_send_paid_media : Bool?
  end
end
