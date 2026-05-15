module TelegramBot
  class PaidMediaInfo
    include JSON::Serializable

    property star_count : Int32
    property paid_media : Array(PaidMedia)
  end

  class PaidMedia
    include JSON::Serializable

    property type : String
    property live_photo : LivePhoto?
    property photo : Array(PhotoSize)?
    property video : Video?
    property width : Int32?
    property height : Int32?
    property duration : Int32?
  end

  class PaidMediaPreview < PaidMedia
  end

  class PaidMediaPhoto < PaidMedia
  end

  class PaidMediaVideo < PaidMedia
  end

  class PaidMediaLivePhoto < PaidMedia
  end
end
