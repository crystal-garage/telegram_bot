module TelegramBot
  class ChatPermissions
    include JSON::Serializable

    property? can_send_messages : Bool?
    property? can_send_audios : Bool?
    property? can_send_documents : Bool?
    property? can_send_photos : Bool?
    property? can_send_videos : Bool?
    property? can_send_video_notes : Bool?
    property? can_send_voice_notes : Bool?
    property? can_send_polls : Bool?
    property? can_send_other_messages : Bool?
    property? can_add_web_page_previews : Bool?
    property? can_change_info : Bool?
    property? can_invite_users : Bool?
    property? can_pin_messages : Bool?
    property? can_manage_topics : Bool?
    property? can_edit_tag : Bool?
    property? can_react_to_messages : Bool?

    def initialize(
      *,
      @can_send_messages = nil,
      @can_send_audios = nil,
      @can_send_documents = nil,
      @can_send_photos = nil,
      @can_send_videos = nil,
      @can_send_video_notes = nil,
      @can_send_voice_notes = nil,
      @can_send_polls = nil,
      @can_send_other_messages = nil,
      @can_add_web_page_previews = nil,
      @can_change_info = nil,
      @can_invite_users = nil,
      @can_pin_messages = nil,
      @can_manage_topics = nil,
      @can_edit_tag = nil,
      @can_react_to_messages = nil,
    )
    end
  end
end
