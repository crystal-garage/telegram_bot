module TelegramBot
  class SuggestedPostInfo
    include JSON::Serializable

    property state : String
    property price : SuggestedPostPrice?
    property send_date : Int32?
  end

  class SuggestedPostApproved
    include JSON::Serializable

    property suggested_post_message : Message?
    property price : SuggestedPostPrice?
    property send_date : Int32
  end

  class SuggestedPostApprovalFailed
    include JSON::Serializable

    property suggested_post_message : Message?
    property price : SuggestedPostPrice
  end

  class SuggestedPostDeclined
    include JSON::Serializable

    property suggested_post_message : Message?
    property comment : String?
  end

  class SuggestedPostPaid
    include JSON::Serializable

    property suggested_post_message : Message?
    property currency : String
    property amount : Int64?
    property star_amount : StarAmount?
  end

  class SuggestedPostRefunded
    include JSON::Serializable

    property suggested_post_message : Message?
    property reason : String
  end
end
