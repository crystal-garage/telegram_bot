module TelegramBot
  abstract class InputPaidMedia
    def to_json(json : JSON::Builder)
      raise "InputPaidMedia subclasses must implement JSON serialization"
    end
  end

  class InputPaidMediaPhoto < InputPaidMedia
    include JSON::Serializable

    property type : String = "photo"
    property media : String | AttachedFile

    def initialize(@media : String | AttachedFile)
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@media, attachments)
    end
  end

  class InputPaidMediaVideo < InputPaidMedia
    include JSON::Serializable

    property type : String = "video"
    property media : String | AttachedFile
    property thumbnail : String | AttachedFile | Nil
    property cover : String | AttachedFile | Nil
    property start_timestamp : Int32?
    property width : Int32?
    property height : Int32?
    property duration : Int32?
    property? supports_streaming : Bool?

    def initialize(
      @media : String | AttachedFile,
      *,
      @thumbnail : String | AttachedFile | Nil = nil,
      @cover : String | AttachedFile | Nil = nil,
      @start_timestamp : Int32? = nil,
      @width : Int32? = nil,
      @height : Int32? = nil,
      @duration : Int32? = nil,
      @supports_streaming = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@media, attachments)
      TelegramBot.collect_attachment(@thumbnail, attachments)
      TelegramBot.collect_attachment(@cover, attachments)
    end
  end

  class InputPaidMediaLivePhoto < InputPaidMedia
    include JSON::Serializable

    property type : String = "live_photo"
    property media : String | AttachedFile
    property photo : String | AttachedFile

    def initialize(@media : String | AttachedFile, @photo : String | AttachedFile)
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@media, attachments)
      TelegramBot.collect_attachment(@photo, attachments)
    end
  end
end
