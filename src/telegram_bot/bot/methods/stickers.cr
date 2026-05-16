module TelegramBot
  class Bot
    # Returns a sticker set.
    #
    # See: <https://core.telegram.org/bots/api#getstickerset>
    def get_sticker_set(
      name : String,
    )
      res = def_request(
        "getStickerSet",
        name
      )

      StickerSet.from_json(res.to_json) if res
    end

    # Uploads a sticker file for later use.
    #
    # See: <https://core.telegram.org/bots/api#uploadstickerfile>
    def upload_sticker_file(
      user_id : Int,
      sticker : ::File,
      sticker_format : String,
    )
      res = def_request(
        "uploadStickerFile",
        user_id,
        sticker,
        sticker_format
      )
      File.from_json(res.to_json) if res
    end

    # Creates a new sticker set for a user.
    #
    # See: <https://core.telegram.org/bots/api#createnewstickerset>
    def create_new_sticker_set(
      user_id : Int,
      name : String,
      title : String,
      stickers : Array(InputSticker),
      sticker_type : String? = nil,
      needs_repainting : Bool? = nil,
    )
      res = def_request(
        "createNewStickerSet",
        user_id,
        name,
        title,
        stickers,
        sticker_type,
        needs_repainting
      )

      res.as_bool if res
    end

    # Adds a sticker to an existing sticker set.
    #
    # See: <https://core.telegram.org/bots/api#addstickertoset>
    def add_sticker_to_set(
      user_id : Int,
      name : String,
      sticker : InputSticker,
    )
      res = def_request(
        "addStickerToSet",
        user_id,
        name,
        sticker
      )

      res.as_bool if res
    end

    # Moves a sticker in a sticker set.
    #
    # See: <https://core.telegram.org/bots/api#setstickerpositioninset>
    def set_sticker_position_in_set(
      sticker : String,
      position : Int,
    )
      res = def_request(
        "setStickerPositionInSet",
        sticker,
        position
      )

      res.as_bool if res
    end

    # Deletes a sticker from a sticker set.
    #
    # See: <https://core.telegram.org/bots/api#deletestickerfromset>
    def delete_sticker_from_set(sticker : String)
      res = def_request(
        "deleteStickerFromSet",
        sticker
      )

      res.as_bool if res
    end
  end
end
