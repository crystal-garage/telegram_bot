module TelegramBot
  class BusinessBotRights
    include JSON::Serializable

    property? can_reply : Bool?
    property? can_read_messages : Bool?
    property? can_delete_sent_messages : Bool?
    property? can_delete_all_messages : Bool?
    property? can_edit_name : Bool?
    property? can_edit_bio : Bool?
    property? can_edit_profile_photo : Bool?
    property? can_edit_username : Bool?
    property? can_change_gift_settings : Bool?
    property? can_view_gifts_and_stars : Bool?
    property? can_convert_gifts_to_stars : Bool?
    property? can_transfer_and_upgrade_gifts : Bool?
    property? can_transfer_stars : Bool?
    property? can_manage_stories : Bool?
  end

  class BusinessIntro
    include JSON::Serializable

    property title : String?
    property message : String?
    property sticker : Sticker?
  end

  class BusinessLocation
    include JSON::Serializable

    property address : String
    property location : Location?
  end

  class BusinessOpeningHoursInterval
    include JSON::Serializable

    property opening_minute : Int32
    property closing_minute : Int32
  end

  class BusinessOpeningHours
    include JSON::Serializable

    property time_zone_name : String
    property opening_hours : Array(BusinessOpeningHoursInterval)
  end

  class InputProfilePhoto
    include JSON::Serializable

    property type : String
    property photo : String?
    property animation : String?
    property main_frame_timestamp : Float64?

    def initialize(
      @type : String,
      *,
      @photo : String? = nil,
      @animation : String? = nil,
      @main_frame_timestamp : Float64? = nil,
    )
    end
  end
end
