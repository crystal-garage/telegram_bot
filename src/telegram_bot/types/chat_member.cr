module TelegramBot
  class ChatMember
    include JSON::Serializable

    property user : User
    property status : String
    property until_date : Int64?
    property? is_anonymous : Bool?
    property custom_title : String?
    property? can_be_edited : Bool?
    property? can_change_info : Bool?
    property? can_post_messages : Bool?
    property? can_edit_messages : Bool?
    property? can_delete_messages : Bool?
    property? can_manage_chat : Bool?
    property? can_manage_video_chats : Bool?
    property? can_invite_users : Bool?
    property? can_restrict_members : Bool?
    property? can_pin_messages : Bool?
    property? can_promote_members : Bool?
    property? can_manage_topics : Bool?
    property? can_manage_direct_messages : Bool?
    property? can_post_stories : Bool?
    property? can_edit_stories : Bool?
    property? can_delete_stories : Bool?
    property? can_manage_tags : Bool?
    property? can_edit_tag : Bool?
    property tag : String?
    property? can_send_messages : Bool?
    property? can_send_audios : Bool?
    property? can_send_documents : Bool?
    property? can_send_photos : Bool?
    property? can_send_videos : Bool?
    property? can_send_video_notes : Bool?
    property? can_send_voice_notes : Bool?
    property? can_send_polls : Bool?
    property? can_send_media_messages : Bool?
    property? can_send_other_messages : Bool?
    property? can_add_web_page_previews : Bool?
    property? can_react_to_messages : Bool?
    property? is_member : Bool?
  end
end
