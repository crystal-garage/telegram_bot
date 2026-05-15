module TelegramBot
  abstract class Bot
    def send_chat_action(
      chat_id : Int | String,
      action : String,
    )
      res = def_request(
        "sendChatAction",
        chat_id,
        action
      )

      res.as_bool if res
    end

    def set_message_reaction(
      chat_id : Int | String,
      message_id : Int,
      reaction : Array(ReactionType)? = nil,
      is_big : Bool? = nil,
    )
      res = def_request(
        "setMessageReaction",
        chat_id,
        message_id,
        reaction,
        is_big
      )

      res.as_bool if res
    end

    def delete_message_reaction(
      chat_id : Int | String,
      message_id : Int,
      reaction : ReactionType,
    )
      res = def_request(
        "deleteMessageReaction",
        chat_id,
        message_id,
        reaction
      )

      res.as_bool if res
    end

    def delete_all_message_reactions(
      chat_id : Int | String,
      message_id : Int,
    )
      res = def_request(
        "deleteAllMessageReactions",
        chat_id,
        message_id
      )

      res.as_bool if res
    end

    def get_user_profile_photos(
      user_id : Int32,
      offset : Int32? = nil,
      limit : Int32? = nil,
    )
      res = def_force_request(
        "getUserProfilePhotos",
        user_id,
        offset,
        limit
      )

      UserProfilePhotos.from_json(res.not_nil!.to_json)
    end

    def ban_chat_member(
      chat_id : Int | String,
      user_id : Int,
      until_date : Int? = nil,
      revoke_messages : Bool? = nil,
    )
      res = def_request(
        "banChatMember",
        chat_id,
        user_id,
        until_date,
        revoke_messages
      )

      res.as_bool if res
    end

    def unban_chat_member(
      chat_id : Int | String,
      user_id : Int32,
    )
      res = def_request(
        "unbanChatMember",
        chat_id,
        user_id
      )

      res.as_bool if res
    end

    def restrict_chat_member(
      chat_id : Int | String,
      user_id : Int,
      permissions : ChatPermissions,
      until_date : Int? = nil,
      use_independent_chat_permissions : Bool? = nil,
    )
      res = def_request(
        "restrictChatMember",
        chat_id,
        user_id,
        permissions,
        use_independent_chat_permissions,
        until_date
      )

      res.as_bool if res
    end

    def promote_chat_member(
      chat_id : Int | String,
      user_id : Int,
      can_change_info : Bool? = nil,
      can_post_messages : Bool? = nil,
      can_edit_messages : Bool? = nil,
      can_delete_messages : Bool? = nil,
      can_invite_users : Bool? = nil,
      can_restrict_members : Bool? = nil,
      can_pin_messages : Bool? = nil,
      can_promote_members : Bool? = nil,
    )
      res = def_request(
        "promoteChatMember",
        chat_id,
        user_id,
        can_change_info,
        can_post_messages,
        can_edit_messages,
        can_delete_messages,
        can_invite_users,
        can_restrict_members,
        can_pin_messages,
        can_promote_members
      )

      res.as_bool if res
    end

    def export_chat_invite_link(
      chat_id : Int | String,
    )
      res = def_request(
        "exportChatInviteLink",
        chat_id
      )

      res if res
    end

    def create_chat_invite_link(
      chat_id : Int | String,
      name : String? = nil,
      expire_date : Int? = nil,
      member_limit : Int32? = nil,
      creates_join_request : Bool? = nil,
    ) : ChatInviteLink?
      res = def_request(
        "createChatInviteLink",
        chat_id,
        name,
        expire_date,
        member_limit,
        creates_join_request
      )

      ChatInviteLink.from_json(res.to_json) if res
    end

    def edit_chat_invite_link(
      chat_id : Int | String,
      invite_link : String,
      name : String? = nil,
      expire_date : Int? = nil,
      member_limit : Int32? = nil,
      creates_join_request : Bool? = nil,
    ) : ChatInviteLink?
      res = def_request(
        "editChatInviteLink",
        chat_id,
        invite_link,
        name,
        expire_date,
        member_limit,
        creates_join_request
      )

      ChatInviteLink.from_json(res.to_json) if res
    end

    def create_chat_subscription_invite_link(
      chat_id : Int | String,
      subscription_period : Int,
      subscription_price : Int,
      name : String? = nil,
    ) : ChatInviteLink?
      res = def_request(
        "createChatSubscriptionInviteLink",
        chat_id,
        name,
        subscription_period,
        subscription_price
      )

      ChatInviteLink.from_json(res.to_json) if res
    end

    def edit_chat_subscription_invite_link(
      chat_id : Int | String,
      invite_link : String,
      name : String? = nil,
    ) : ChatInviteLink?
      res = def_request(
        "editChatSubscriptionInviteLink",
        chat_id,
        invite_link,
        name
      )

      ChatInviteLink.from_json(res.to_json) if res
    end

    def revoke_chat_invite_link(
      chat_id : Int | String,
      invite_link : String,
    ) : ChatInviteLink?
      res = def_request(
        "revokeChatInviteLink",
        chat_id,
        invite_link
      )

      ChatInviteLink.from_json(res.to_json) if res
    end

    def approve_chat_join_request(
      chat_id : Int | String,
      user_id : Int,
    )
      res = def_request(
        "approveChatJoinRequest",
        chat_id,
        user_id
      )

      res.as_bool if res
    end

    def decline_chat_join_request(
      chat_id : Int | String,
      user_id : Int,
    )
      res = def_request(
        "declineChatJoinRequest",
        chat_id,
        user_id
      )

      res.as_bool if res
    end

    def set_chat_photo(
      chat_id : Int | String,
      photo : ::File,
    )
      res = def_request(
        "setChatPhoto",
        chat_id,
        photo
      )

      res.as_bool if res
    end

    def delete_chat_photo(
      chat_id : Int | String,
    )
      res = def_request(
        "deleteChatPhoto",
        chat_id
      )

      res.as_bool if res
    end

    def set_chat_title(
      chat_id : Int | String,
      title : String,
    )
      res = def_request(
        "setChatTitle",
        chat_id,
        title
      )

      res.as_bool if res
    end

    def set_chat_description(
      chat_id : Int | String,
      description : String,
    )
      res = def_request(
        "setChatDescription",
        chat_id,
        description
      )

      res.as_bool if res
    end

    def pin_chat_message(
      chat_id : Int | String,
      message_id : Int,
      disable_notification : Bool? = nil,
    )
      res = def_request(
        "pinChatMessage",
        chat_id,
        message_id,
        disable_notification
      )

      res.as_bool if res
    end

    def unpin_chat_message(
      chat_id : Int | String,
    )
      res = def_request(
        "unpinChatMessage",
        chat_id
      )

      res.as_bool if res
    end

    def get_chat(
      chat_id : Int | String,
    )
      res = def_request(
        "getChat",
        chat_id
      )

      Chat.from_json(res.not_nil!.to_json)
    end

    def leave_chat(
      chat_id : Int | String,
    )
      res = def_request(
        "leaveChat",
        chat_id
      )

      res.as_bool if res
    end

    def get_chat_administrators(
      chat_id : Int | String,
    )
      res = def_request(
        "getChatAdministrators",
        chat_id
      )
      res = res.not_nil!.as_a
      admins = Array(ChatMember).new
      res.each { |m| admins << ChatMember.from_json(m.to_json) }

      admins
    end

    def get_chat_member(
      chat_id : Int | String,
      user_id : Int32,
    )
      res = def_request(
        "getChatMember",
        chat_id,
        user_id
      )

      ChatMember.from_json(res.not_nil!.to_json)
    end

    def get_chat_member_count(
      chat_id : Int | String,
    )
      res = def_request(
        "getChatMemberCount",
        chat_id
      )

      res.as_i if res
    end

    def set_chat_sticker_set(
      chat_id : Int | String,
      sticker_set_name : String,
    )
      res = def_request(
        "setChatStickerSet",
        chat_id,
        sticker_set_name
      )

      res.as_bool if res
    end

    def delete_chat_sticker_set(
      chat_id : Int | String,
    )
      res = def_request(
        "deleteChatStickerSet",
        chat_id
      )

      res.as_bool if res
    end

    def get_forum_topic_icon_stickers : Array(Sticker)
      res = request(
        "getForumTopicIconStickers",
        force_http: true
      )
      res = res.not_nil!.as_a
      stickers = Array(Sticker).new
      res.each { |sticker| stickers << Sticker.from_json(sticker.to_json) }

      stickers
    end

    def create_forum_topic(
      chat_id : Int | String,
      name : String,
      icon_color : Int32? = nil,
      icon_custom_emoji_id : String? = nil,
    ) : ForumTopic?
      res = def_request(
        "createForumTopic",
        chat_id,
        name,
        icon_color,
        icon_custom_emoji_id
      )

      ForumTopic.from_json(res.to_json) if res
    end

    def edit_forum_topic(
      chat_id : Int | String,
      message_thread_id : Int,
      name : String? = nil,
      icon_custom_emoji_id : String? = nil,
    )
      res = def_request(
        "editForumTopic",
        chat_id,
        message_thread_id,
        name,
        icon_custom_emoji_id
      )

      res.as_bool if res
    end

    def close_forum_topic(
      chat_id : Int | String,
      message_thread_id : Int,
    )
      res = def_request(
        "closeForumTopic",
        chat_id,
        message_thread_id
      )

      res.as_bool if res
    end

    def reopen_forum_topic(
      chat_id : Int | String,
      message_thread_id : Int,
    )
      res = def_request(
        "reopenForumTopic",
        chat_id,
        message_thread_id
      )

      res.as_bool if res
    end

    def delete_forum_topic(
      chat_id : Int | String,
      message_thread_id : Int,
    )
      res = def_request(
        "deleteForumTopic",
        chat_id,
        message_thread_id
      )

      res.as_bool if res
    end

    def unpin_all_forum_topic_messages(
      chat_id : Int | String,
      message_thread_id : Int,
    )
      res = def_request(
        "unpinAllForumTopicMessages",
        chat_id,
        message_thread_id
      )

      res.as_bool if res
    end

    def edit_general_forum_topic(
      chat_id : Int | String,
      name : String,
    )
      res = def_request(
        "editGeneralForumTopic",
        chat_id,
        name
      )

      res.as_bool if res
    end

    def close_general_forum_topic(
      chat_id : Int | String,
    )
      res = def_request(
        "closeGeneralForumTopic",
        chat_id
      )

      res.as_bool if res
    end

    def reopen_general_forum_topic(
      chat_id : Int | String,
    )
      res = def_request(
        "reopenGeneralForumTopic",
        chat_id
      )

      res.as_bool if res
    end

    def hide_general_forum_topic(
      chat_id : Int | String,
    )
      res = def_request(
        "hideGeneralForumTopic",
        chat_id
      )

      res.as_bool if res
    end

    def unhide_general_forum_topic(
      chat_id : Int | String,
    )
      res = def_request(
        "unhideGeneralForumTopic",
        chat_id
      )

      res.as_bool if res
    end

    def unpin_all_general_forum_topic_messages(
      chat_id : Int | String,
    )
      res = def_request(
        "unpinAllGeneralForumTopicMessages",
        chat_id
      )

      res.as_bool if res
    end
  end
end
