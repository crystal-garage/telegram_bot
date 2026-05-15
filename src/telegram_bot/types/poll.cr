module TelegramBot
  class PollOption
    include JSON::Serializable

    property text : String?
    property text_entities : Array(MessageEntity)?
    property voter_count : Int32?
    property persistent_id : String?
    property added_by_user : User?
    property added_by_chat : Chat?
    property addition_date : Int32?
    property media : JSON::Any?
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
    property media : JSON::Any?
    property explanation_media : JSON::Any?
    property? members_only : Bool?
    property country_codes : Array(String)?
  end
end
