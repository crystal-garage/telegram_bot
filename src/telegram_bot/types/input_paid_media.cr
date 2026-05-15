module TelegramBot
  abstract class InputPaidMedia
    def to_json(json : JSON::Builder)
      raise "InputPaidMedia subclasses must implement JSON serialization"
    end
  end

  class InputPaidMediaPhoto < InputPaidMedia
    include JSON::Serializable

    property type : String = "photo"
    property media : String

    def initialize(@media : String)
    end
  end

  class InputPaidMediaVideo < InputPaidMedia
    include JSON::Serializable

    property type : String = "video"
    property media : String
    property thumbnail : String?
    property cover : String?
    property start_timestamp : Int32?
    property width : Int32?
    property height : Int32?
    property duration : Int32?
    property? supports_streaming : Bool?

    def initialize(
      @media : String,
      *,
      @thumbnail : String? = nil,
      @cover : String? = nil,
      @start_timestamp : Int32? = nil,
      @width : Int32? = nil,
      @height : Int32? = nil,
      @duration : Int32? = nil,
      @supports_streaming = nil,
    )
    end
  end

  class InputPaidMediaLivePhoto < InputPaidMedia
    include JSON::Serializable

    property type : String = "live_photo"
    property media : String
    property thumbnail : String?
    property cover : String?
    property start_timestamp : Int32?
    property width : Int32?
    property height : Int32?
    property duration : Int32?
    property? supports_streaming : Bool?

    def initialize(
      @media : String,
      *,
      @thumbnail : String? = nil,
      @cover : String? = nil,
      @start_timestamp : Int32? = nil,
      @width : Int32? = nil,
      @height : Int32? = nil,
      @duration : Int32? = nil,
      @supports_streaming = nil,
    )
    end
  end
end
