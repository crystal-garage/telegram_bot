module TelegramBot
  class ChatAdministratorRights
    include JSON::Serializable

    property? is_anonymous : Bool
    property? can_manage_chat : Bool
    property? can_delete_messages : Bool
    property? can_manage_video_chats : Bool
    property? can_restrict_members : Bool
    property? can_promote_members : Bool
    property? can_change_info : Bool
    property? can_invite_users : Bool
    property? can_post_stories : Bool
    property? can_edit_stories : Bool
    property? can_delete_stories : Bool
    property? can_post_messages : Bool?
    property? can_edit_messages : Bool?
    property? can_pin_messages : Bool?
    property? can_manage_topics : Bool?
    property? can_manage_direct_messages : Bool?
    property? can_manage_tags : Bool?

    def initialize(
      *,
      @is_anonymous : Bool = false,
      @can_manage_chat : Bool = false,
      @can_delete_messages : Bool = false,
      @can_manage_video_chats : Bool = false,
      @can_restrict_members : Bool = false,
      @can_promote_members : Bool = false,
      @can_change_info : Bool = false,
      @can_invite_users : Bool = false,
      @can_post_stories : Bool = false,
      @can_edit_stories : Bool = false,
      @can_delete_stories : Bool = false,
      @can_post_messages = nil,
      @can_edit_messages = nil,
      @can_pin_messages = nil,
      @can_manage_topics = nil,
      @can_manage_direct_messages = nil,
      @can_manage_tags = nil,
    )
    end
  end
end
