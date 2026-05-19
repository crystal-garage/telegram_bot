module TelegramBot
  class Birthdate
    include JSON::Serializable

    property day : Int32
    property month : Int32
    property year : Int32?
  end

  class ChatLocation
    include JSON::Serializable

    property location : Location
    property address : String
  end

  class UserRating
    include JSON::Serializable

    property level : Int32
  end

  class ChatFullInfo < Chat
    property accent_color_id : Int32
    property max_reaction_count : Int32
    property active_usernames : Array(String)?
    property direct_messages_topic : DirectMessagesTopic?
    property birthdate : Birthdate?
    property personal_chat : Chat?
    property parent_chat : Chat?
    property available_reactions : Array(ReactionType)?
    property background_custom_emoji_id : String?
    property profile_accent_color_id : Int32?
    property profile_background_custom_emoji_id : String?
    property emoji_status_custom_emoji_id : String?
    property emoji_status_expiration_date : Int32?
    property bio : String?
    property? has_private_forwards : Bool?
    property? has_restricted_voice_and_video_messages : Bool?
    property? join_to_send_messages : Bool?
    property? join_by_request : Bool?
    property permissions : ChatPermissions?
    property slow_mode_delay : Int32?
    property unrestrict_boost_count : Int32?
    property message_auto_delete_time : Int32?
    property? has_aggressive_anti_spam_enabled : Bool?
    property? has_hidden_members : Bool?
    property? has_protected_content : Bool?
    property? has_visible_history : Bool?
    property custom_emoji_sticker_set_name : String?
    property linked_chat_id : Int64?
    property location : ChatLocation?
    property rating : UserRating?
    property first_profile_audio : Audio?
    property unique_gift_colors : UniqueGiftColors?
    property paid_message_star_count : Int32?
  end
end
