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

    # Returns custom emoji stickers by identifier.
    #
    # See: <https://core.telegram.org/bots/api#getcustomemojistickers>
    def get_custom_emoji_stickers(
      custom_emoji_ids : Array(String),
    ) : Array(Sticker)
      res = def_request(
        "getCustomEmojiStickers",
        custom_emoji_ids
      )
      res = res.not_nil!.as_a
      stickers = Array(Sticker).new
      res.each { |sticker| stickers << Sticker.from_json(sticker.to_json) }

      stickers
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

    # Replaces an existing sticker in a set.
    #
    # See: <https://core.telegram.org/bots/api#replacestickerinset>
    def replace_sticker_in_set(
      user_id : Int,
      name : String,
      old_sticker : String,
      sticker : InputSticker,
    )
      res = def_request(
        "replaceStickerInSet",
        user_id,
        name,
        old_sticker,
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

    # Changes the emoji list assigned to a sticker.
    #
    # See: <https://core.telegram.org/bots/api#setstickeremojilist>
    def set_sticker_emoji_list(
      sticker : String,
      emoji_list : Array(String),
    )
      res = def_request(
        "setStickerEmojiList",
        sticker,
        emoji_list
      )

      res.as_bool if res
    end

    # Changes search keywords assigned to a sticker.
    #
    # See: <https://core.telegram.org/bots/api#setstickerkeywords>
    def set_sticker_keywords(
      sticker : String,
      keywords : Array(String)? = nil,
    )
      res = def_request(
        "setStickerKeywords",
        sticker,
        keywords
      )

      res.as_bool if res
    end

    # Changes the mask position assigned to a mask sticker.
    #
    # See: <https://core.telegram.org/bots/api#setstickermaskposition>
    def set_sticker_mask_position(
      sticker : String,
      mask_position : MaskPosition? = nil,
    )
      res = def_request(
        "setStickerMaskPosition",
        sticker,
        mask_position
      )

      res.as_bool if res
    end

    # Changes a sticker set title.
    #
    # See: <https://core.telegram.org/bots/api#setstickersettitle>
    def set_sticker_set_title(
      name : String,
      title : String,
    )
      res = def_request(
        "setStickerSetTitle",
        name,
        title
      )

      res.as_bool if res
    end

    # Sets the thumbnail of a regular, mask, or custom emoji sticker set.
    #
    # See: <https://core.telegram.org/bots/api#setstickersetthumbnail>
    def set_sticker_set_thumbnail(
      name : String,
      user_id : Int,
      format : String,
      thumbnail : ::File | String? = nil,
    )
      res = def_request(
        "setStickerSetThumbnail",
        name,
        user_id,
        thumbnail,
        format
      )

      res.as_bool if res
    end

    # Sets the thumbnail of a custom emoji sticker set.
    #
    # See: <https://core.telegram.org/bots/api#setcustomemojistickersetthumbnail>
    def set_custom_emoji_sticker_set_thumbnail(
      name : String,
      custom_emoji_id : String? = nil,
    )
      res = def_request(
        "setCustomEmojiStickerSetThumbnail",
        name,
        custom_emoji_id
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

    # Deletes a sticker set created by the bot.
    #
    # See: <https://core.telegram.org/bots/api#deletestickerset>
    def delete_sticker_set(name : String)
      res = def_request(
        "deleteStickerSet",
        name
      )

      res.as_bool if res
    end
  end
end
