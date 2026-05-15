module TelegramBot
  class Sticker
    include JSON::Serializable

    property file_id : String
    property width : Int32
    property height : Int32
    property thumbnail : PhotoSize?
    property emoji : String?
    property set_name : String?
    property mask_position : MaskPosition?
    property file_size : Int32?
  end
end
