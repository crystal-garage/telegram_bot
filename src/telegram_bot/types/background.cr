module TelegramBot
  class BackgroundFill
    include JSON::Serializable

    property type : String
    property color : Int32?
    property top_color : Int32?
    property bottom_color : Int32?
    property rotation_angle : Int32?
    property colors : Array(Int32)?
  end

  class BackgroundFillSolid < BackgroundFill
  end

  class BackgroundFillGradient < BackgroundFill
  end

  class BackgroundFillFreeformGradient < BackgroundFill
  end

  class BackgroundType
    include JSON::Serializable

    property type : String
    property fill : BackgroundFill?
    property dark_theme_dimming : Int32?
    property document : Document?
    property? is_blurred : Bool?
    property? is_moving : Bool?
    property intensity : Int32?
    property? is_inverted : Bool?
    property theme_name : String?
  end

  class BackgroundTypeFill < BackgroundType
  end

  class BackgroundTypeWallpaper < BackgroundType
  end

  class BackgroundTypePattern < BackgroundType
  end

  class BackgroundTypeChatTheme < BackgroundType
  end

  class ChatBackground
    include JSON::Serializable

    property type : BackgroundType
  end
end
