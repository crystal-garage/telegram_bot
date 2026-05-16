module TelegramBot
  class InputSticker
    include JSON::Serializable

    property sticker : String
    property format : String
    property emoji_list : Array(String)
    property mask_position : MaskPosition?
    property keywords : Array(String)?

    def initialize(
      @sticker : String,
      @format : String,
      @emoji_list : Array(String),
      @mask_position : MaskPosition? = nil,
      @keywords : Array(String)? = nil,
    )
    end
  end
end
