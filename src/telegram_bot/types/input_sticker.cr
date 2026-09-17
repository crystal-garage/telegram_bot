module TelegramBot
  class InputSticker
    include JSON::Serializable

    property sticker : String | AttachedFile
    property format : String
    property emoji_list : Array(String)
    property mask_position : MaskPosition?
    property keywords : Array(String)?

    def initialize(
      @sticker : String | AttachedFile,
      @format : String,
      @emoji_list : Array(String),
      @mask_position : MaskPosition? = nil,
      @keywords : Array(String)? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@sticker, attachments)
    end
  end
end
