module TelegramBot
  abstract class BackgroundFill
    include JSON::Serializable

    use_json_discriminator "type", {
      freeform_gradient: BackgroundFillFreeformGradient,
      gradient:          BackgroundFillGradient,
      solid:             BackgroundFillSolid,
    }

    property type : String
  end

  class BackgroundFillSolid < BackgroundFill
    include JSON::Serializable

    property type : String
    property color : Int32
  end

  class BackgroundFillGradient < BackgroundFill
    include JSON::Serializable

    property type : String
    property top_color : Int32
    property bottom_color : Int32
    property rotation_angle : Int32
  end

  class BackgroundFillFreeformGradient < BackgroundFill
    include JSON::Serializable

    property type : String
    property colors : Array(Int32)
  end

  abstract class BackgroundType
    include JSON::Serializable

    use_json_discriminator "type", {
      chat_theme: BackgroundTypeChatTheme,
      fill:       BackgroundTypeFill,
      pattern:    BackgroundTypePattern,
      wallpaper:  BackgroundTypeWallpaper,
    }

    property type : String
  end

  class BackgroundTypeFill < BackgroundType
    include JSON::Serializable

    property type : String
    property fill : BackgroundFill
    property dark_theme_dimming : Int32
  end

  class BackgroundTypeWallpaper < BackgroundType
    include JSON::Serializable

    property type : String
    property document : Document
    property dark_theme_dimming : Int32
    property? is_blurred : Bool?
    property? is_moving : Bool?
  end

  class BackgroundTypePattern < BackgroundType
    include JSON::Serializable

    property type : String
    property document : Document
    property fill : BackgroundFill
    property intensity : Int32
    property? is_inverted : Bool?
    property? is_moving : Bool?
  end

  class BackgroundTypeChatTheme < BackgroundType
    include JSON::Serializable

    property type : String
    property theme_name : String
  end

  class ChatBackground
    include JSON::Serializable

    property type : BackgroundType
  end
end
