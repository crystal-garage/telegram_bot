module TelegramBot
  class Sticker
    include JSON::Serializable

    property file_id : String
    property file_unique_id : String
    property type : String
    property width : Int32
    property height : Int32
    property? is_animated : Bool
    property? is_video : Bool
    property thumbnail : PhotoSize?
    property emoji : String?
    property set_name : String?
    property premium_animation : File?
    property mask_position : MaskPosition?
    property custom_emoji_id : String?
    property? needs_repainting : Bool?
    property file_size : Int64?
  end
end
