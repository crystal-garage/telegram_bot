module TelegramBot
  class ChatAdministratorRights
    include JSON::Serializable

    property? is_anonymous : Bool?
    property? can_manage_chat : Bool?
    property? can_delete_messages : Bool?
    property? can_manage_video_chats : Bool?
    property? can_restrict_members : Bool?
    property? can_promote_members : Bool?
    property? can_change_info : Bool?
    property? can_invite_users : Bool?
    property? can_post_stories : Bool?
    property? can_edit_stories : Bool?
    property? can_delete_stories : Bool?
    property? can_post_messages : Bool?
    property? can_edit_messages : Bool?
    property? can_pin_messages : Bool?
    property? can_manage_topics : Bool?
    property? can_manage_direct_messages : Bool?
    property? can_manage_tags : Bool?

    def initialize(
      *,
      @is_anonymous = nil,
      @can_manage_chat = nil,
      @can_delete_messages = nil,
      @can_manage_video_chats = nil,
      @can_restrict_members = nil,
      @can_promote_members = nil,
      @can_change_info = nil,
      @can_invite_users = nil,
      @can_post_stories = nil,
      @can_edit_stories = nil,
      @can_delete_stories = nil,
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
