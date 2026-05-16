module TelegramBot
  class Story
    include JSON::Serializable

    property chat : Chat
    property id : Int32
  end

  class InputStoryContent
    include JSON::Serializable

    property type : String
    property photo : String?
    property video : String?
    property duration : Float64?
    property cover_frame_timestamp : Float64?
    property? is_animation : Bool?
  end

  class InputStoryContentPhoto < InputStoryContent
    def initialize(@photo : String)
      @type = "photo"
      @video = nil
      @duration = nil
      @cover_frame_timestamp = nil
      @is_animation = nil
    end
  end

  class InputStoryContentVideo < InputStoryContent
    def initialize(
      @video : String,
      *,
      @duration : Float64? = nil,
      @cover_frame_timestamp : Float64? = nil,
      @is_animation : Bool? = nil,
    )
      @type = "video"
      @photo = nil
    end
  end

  class StoryAreaPosition
    include JSON::Serializable

    property x_percentage : Float64
    property y_percentage : Float64
    property width_percentage : Float64
    property height_percentage : Float64
    property rotation_angle : Float64
    property corner_radius_percentage : Float64

    def initialize(
      @x_percentage : Float64,
      @y_percentage : Float64,
      @width_percentage : Float64,
      @height_percentage : Float64,
      @rotation_angle : Float64,
      @corner_radius_percentage : Float64,
    )
    end
  end

  class LocationAddress
    include JSON::Serializable

    property country_code : String
    property state : String?
    property city : String?
    property street : String?

    def initialize(
      @country_code : String,
      *,
      @state : String? = nil,
      @city : String? = nil,
      @street : String? = nil,
    )
    end
  end

  class StoryAreaType
    include JSON::Serializable

    property type : String
    property latitude : Float64?
    property longitude : Float64?
    property address : LocationAddress?
    property reaction_type : ReactionType?
    property? is_dark : Bool?
    property? is_flipped : Bool?
    property url : String?
    property temperature : Float64?
    property emoji : String?
    property background_color : Int32?
    property name : String?
  end

  class StoryAreaTypeLocation < StoryAreaType
    def initialize(
      @latitude : Float64,
      @longitude : Float64,
      *,
      @address : LocationAddress? = nil,
    )
      @type = "location"
      @reaction_type = nil
      @is_dark = nil
      @is_flipped = nil
      @url = nil
      @temperature = nil
      @emoji = nil
      @background_color = nil
      @name = nil
    end
  end

  class StoryAreaTypeSuggestedReaction < StoryAreaType
    def initialize(
      @reaction_type : ReactionType,
      *,
      @is_dark : Bool? = nil,
      @is_flipped : Bool? = nil,
    )
      @type = "suggested_reaction"
      @latitude = nil
      @longitude = nil
      @address = nil
      @url = nil
      @temperature = nil
      @emoji = nil
      @background_color = nil
      @name = nil
    end
  end

  class StoryAreaTypeLink < StoryAreaType
    def initialize(@url : String)
      @type = "link"
      @latitude = nil
      @longitude = nil
      @address = nil
      @reaction_type = nil
      @is_dark = nil
      @is_flipped = nil
      @temperature = nil
      @emoji = nil
      @background_color = nil
      @name = nil
    end
  end

  class StoryAreaTypeWeather < StoryAreaType
    def initialize(
      @temperature : Float64,
      @emoji : String,
      @background_color : Int32,
    )
      @type = "weather"
      @latitude = nil
      @longitude = nil
      @address = nil
      @reaction_type = nil
      @is_dark = nil
      @is_flipped = nil
      @url = nil
      @name = nil
    end
  end

  class StoryAreaTypeUniqueGift < StoryAreaType
    def initialize(@name : String)
      @type = "unique_gift"
      @latitude = nil
      @longitude = nil
      @address = nil
      @reaction_type = nil
      @is_dark = nil
      @is_flipped = nil
      @url = nil
      @temperature = nil
      @emoji = nil
      @background_color = nil
    end
  end

  class StoryArea
    include JSON::Serializable

    property position : StoryAreaPosition
    property type : StoryAreaType

    def initialize(@position : StoryAreaPosition, @type : StoryAreaType)
    end
  end
end
