module TelegramBot
  class PaidMediaInfo
    include JSON::Serializable

    property star_count : Int32
    property paid_media : Array(PaidMedia)
  end

  abstract class PaidMedia
    include JSON::Serializable

    use_json_discriminator "type", {
      live_photo: PaidMediaLivePhoto,
      photo:      PaidMediaPhoto,
      preview:    PaidMediaPreview,
      video:      PaidMediaVideo,
    }

    property type : String
  end

  class PaidMediaPreview < PaidMedia
    include JSON::Serializable

    property type : String
    property width : Int32?
    property height : Int32?
    property duration : Int32?
  end

  class PaidMediaPhoto < PaidMedia
    include JSON::Serializable

    property type : String
    property photo : Array(PhotoSize)
  end

  class PaidMediaVideo < PaidMedia
    include JSON::Serializable

    property type : String
    property video : Video
  end

  class PaidMediaLivePhoto < PaidMedia
    include JSON::Serializable

    property type : String
    property live_photo : LivePhoto
  end
end
