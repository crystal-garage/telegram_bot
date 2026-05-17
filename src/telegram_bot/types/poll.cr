module TelegramBot
  class PollMedia
    include JSON::Serializable

    property animation : Animation?
    property audio : Audio?
    property document : Document?
    property live_photo : LivePhoto?
    property location : Location?
    property photo : Array(PhotoSize)?
    property sticker : Sticker?
    property venue : Venue?
    property video : Video?
  end

  alias InputPollMedia = InputMediaAnimation | InputMediaAudio | InputMediaDocument | InputMediaLivePhoto | InputMediaLocation | InputMediaPhoto | InputMediaVenue | InputMediaVideo
  alias InputPollOptionMedia = InputMediaAnimation | InputMediaLivePhoto | InputMediaLocation | InputMediaPhoto | InputMediaSticker | InputMediaVenue | InputMediaVideo

  class PollOption
    include JSON::Serializable

    property text : String?
    property text_entities : Array(MessageEntity)?
    property voter_count : Int32?
    property persistent_id : String?
    property added_by_user : User?
    property added_by_chat : Chat?
    property addition_date : Int32?
    property media : PollMedia?
  end

  class InputPollOption
    include JSON::Serializable

    property text : String
    property text_parse_mode : String?
    property text_entities : Array(MessageEntity)?
    property media : InputPollOptionMedia?

    def initialize(
      @text : String,
      *,
      @text_parse_mode = nil,
      @text_entities = nil,
      @media = nil,
    )
    end
  end

  class Poll
    include JSON::Serializable

    property id : String?
    property question : String?
    property question_entities : Array(MessageEntity)?
    property options : Array(PollOption)?
    property total_voter_count : Int32?
    property? is_closed : Bool?
    property? is_anonymous : Bool?
    property type : String?
    property? allows_multiple_answers : Bool?
    property correct_option_ids : Array(Int32)?
    property explanation : String?
    property explanation_entities : Array(MessageEntity)?
    property open_period : Int32?
    property close_date : Int32?
    property? allows_revoting : Bool?
    property description : String?
    property description_entities : Array(MessageEntity)?
    property media : PollMedia?
    property explanation_media : PollMedia?
    property? members_only : Bool?
    property country_codes : Array(String)?
  end

  class PollOptionAdded
    include JSON::Serializable

    property poll_message : MaybeInaccessibleMessage?
    property option_persistent_id : String
    property option_text : String
    property option_text_entities : Array(MessageEntity)?
  end

  class PollOptionDeleted
    include JSON::Serializable

    property poll_message : MaybeInaccessibleMessage?
    property option_persistent_id : String
    property option_text : String
    property option_text_entities : Array(MessageEntity)?
  end
end
