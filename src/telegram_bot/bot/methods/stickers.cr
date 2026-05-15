module TelegramBot
  abstract class Bot
    # Returns a sticker set.
    #
    # See: https://core.telegram.org/bots/api#getstickerset
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
    # See: https://core.telegram.org/bots/api#uploadstickerfile
    def upload_sticker_file(
      user_id : Int,
      png_sticker : ::File,
    )
      res = def_request(
        "uploadStickerFile",
        user_id,
        png_sticker
      )
      File.from_json(res.to_json) if res
    end

    # Creates a new sticker set for a user.
    #
    # See: https://core.telegram.org/bots/api#createnewstickerset
    def create_new_sticker_set(
      user_id : Int,
      name : String,
      title : String,
      png_sticker : ::File | String,
      emojis : String,
      contains_masks : Bool? = nil,
      mask_position : MaskPosition? = nil,
    )
      res = def_request(
        "createNewStickerSet",
        user_id,
        name,
        title,
        png_sticker,
        emojis,
        contains_masks,
        mask_position
      )

      res.as_bool if res
    end

    # Adds a sticker to an existing sticker set.
    #
    # See: https://core.telegram.org/bots/api#addstickertoset
    def add_sticker_to_set(
      user_id : Int,
      name : String,
      png_sticker : ::File | String,
      emojis : String,
      mask_position : MaskPosition? = nil,
    )
      res = def_request(
        "addStickerToSet",
        user_id,
        name,
        png_sticker,
        emojis,
        mask_position
      )

      res.as_bool if res
    end

    # Moves a sticker in a sticker set.
    #
    # See: https://core.telegram.org/bots/api#setstickerpositioninset
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
    # See: https://core.telegram.org/bots/api#deletestickerfromset
    def delete_sticker_position_in_set(sticker : String)
      res = def_request(
        "deleteStickerFromSet",
        sticker
      )

      res.as_bool if res
    end
  end
end
