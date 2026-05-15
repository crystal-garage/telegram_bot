module TelegramBot
  class GiftBackground
    include JSON::Serializable

    property center_color : Int32
    property edge_color : Int32
    property text_color : Int32
  end

  class Gift
    include JSON::Serializable

    property id : String
    property sticker : Sticker
    property star_count : Int32
    property upgrade_star_count : Int32?
    property? is_premium : Bool?
    property? has_colors : Bool?
    property total_count : Int32?
    property remaining_count : Int32?
    property personal_total_count : Int32?
    property personal_remaining_count : Int32?
    property background : GiftBackground?
    property unique_gift_variant_count : Int32?
    property publisher_chat : Chat?
  end

  class Gifts
    include JSON::Serializable

    property gifts : Array(Gift)
  end

  class UniqueGiftModel
    include JSON::Serializable

    property name : String
    property sticker : Sticker
    property rarity_per_mille : Int32
    property rarity : String?
  end

  class UniqueGiftSymbol
    include JSON::Serializable

    property name : String
    property sticker : Sticker
    property rarity_per_mille : Int32
  end

  class UniqueGiftBackdropColors
    include JSON::Serializable

    property center_color : Int32
    property edge_color : Int32
    property symbol_color : Int32
    property text_color : Int32
  end

  class UniqueGiftBackdrop
    include JSON::Serializable

    property name : String
    property colors : UniqueGiftBackdropColors
    property rarity_per_mille : Int32
  end

  class UniqueGiftColors
    include JSON::Serializable

    property model_custom_emoji_id : String
    property symbol_custom_emoji_id : String
    property light_theme_main_color : Int32
    property light_theme_other_colors : Array(Int32)
    property dark_theme_main_color : Int32
    property dark_theme_other_colors : Array(Int32)
  end

  class UniqueGift
    include JSON::Serializable

    property gift_id : String
    property base_name : String
    property name : String
    property number : Int32
    property model : UniqueGiftModel
    property symbol : UniqueGiftSymbol
    property backdrop : UniqueGiftBackdrop
    property? is_premium : Bool?
    property? is_burned : Bool?
    property? is_from_blockchain : Bool?
    property colors : UniqueGiftColors?
    property publisher_chat : Chat?
  end

  class GiftInfo
    include JSON::Serializable

    property gift : Gift
    property owned_gift_id : String?
    property convert_star_count : Int32?
    property prepaid_upgrade_star_count : Int32?
    property? is_upgrade_separate : Bool?
    property? can_be_upgraded : Bool?
    property text : String?
    property entities : Array(MessageEntity)?
    property? is_private : Bool?
    property unique_gift_number : Int32?
  end

  class UniqueGiftInfo
    include JSON::Serializable

    property gift : UniqueGift
    property origin : String
    property last_resale_currency : String?
    property last_resale_amount : Int32?
    property owned_gift_id : String?
    property transfer_star_count : Int32?
    property next_transfer_date : Int32?
  end

  class OwnedGift
    include JSON::Serializable

    property type : String
    property gift : Gift?
    property unique_gift : UniqueGift?
    property owned_gift_id : String?
    property sender_user : User?
    property send_date : Int32?
    property text : String?
    property entities : Array(MessageEntity)?
    property? is_private : Bool?
    property? is_saved : Bool?
    property? can_be_upgraded : Bool?
    property? was_refunded : Bool?
    property convert_star_count : Int32?
    property prepaid_upgrade_star_count : Int32?
    property? is_upgrade_separate : Bool?
    property unique_gift_number : Int32?
    property? can_be_transferred : Bool?
    property transfer_star_count : Int32?
    property next_transfer_date : Int32?
  end

  class OwnedGifts
    include JSON::Serializable

    property total_count : Int32
    property gifts : Array(OwnedGift)
    property next_offset : String?
  end

  class AcceptedGiftTypes
    include JSON::Serializable

    property? unlimited_gifts : Bool
    property? limited_gifts : Bool
    property? unique_gifts : Bool
    property? premium_subscription : Bool
    property? gifts_from_channels : Bool

    def initialize(
      @unlimited_gifts : Bool,
      @limited_gifts : Bool,
      @unique_gifts : Bool,
      @premium_subscription : Bool,
      @gifts_from_channels : Bool,
    )
    end
  end
end
