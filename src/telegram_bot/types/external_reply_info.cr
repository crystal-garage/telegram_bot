module TelegramBot
  class ExternalReplyInfo
    include JSON::Serializable

    property origin : MessageOrigin
    property chat : Chat?
    property message_id : Int32?
    property link_preview_options : LinkPreviewOptions?
    property animation : Animation?
    property audio : Audio?
    property document : Document?
    property live_photo : LivePhoto?
    property paid_media : PaidMediaInfo?
    property photo : Array(PhotoSize)?
    property sticker : Sticker?
    property story : JSON::Any?
    property video : Video?
    property video_note : VideoNote?
    property voice : Voice?
    property? has_media_spoiler : Bool?
    property checklist : JSON::Any?
    property contact : Contact?
    property dice : Dice?
    property game : Game?
    property giveaway : Giveaway?
    property giveaway_winners : GiveawayWinners?
    property invoice : Invoice?
    property location : Location?
    property poll : Poll?
    property venue : Venue?
  end
end
