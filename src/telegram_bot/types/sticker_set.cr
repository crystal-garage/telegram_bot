module TelegramBot
  class StickerSet
    include JSON::Serializable

    property name : String
    property title : String
    property sticker_type : String
    property stickers : Array(Sticker)
    property thumbnail : PhotoSize?
  end
end
