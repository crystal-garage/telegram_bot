module TelegramBot
  class User
    include JSON::Serializable

    property id : Int64
    property? is_bot : Bool
    property first_name : String
    property last_name : String?
    property username : String?
    property language_code : String?
    property? is_premium : Bool?
    property? added_to_attachment_menu : Bool?
    property? can_join_groups : Bool?
    property? can_read_all_group_messages : Bool?
    property? supports_guest_queries : Bool?
    property? supports_inline_queries : Bool?
    property? can_connect_to_business : Bool?
    property? has_main_web_app : Bool?
    property? has_topics_enabled : Bool?
    property? allows_users_to_create_topics : Bool?
    property? can_manage_bots : Bool?

    def initialize(
      @id : Int64,
      @is_bot : Bool,
      @first_name : String,
      *,
      @last_name = nil,
      @username = nil,
      @language_code = nil,
      @is_premium = nil,
      @added_to_attachment_menu = nil,
      @can_join_groups = nil,
      @can_read_all_group_messages = nil,
      @supports_guest_queries = nil,
      @supports_inline_queries = nil,
      @can_connect_to_business = nil,
      @has_main_web_app = nil,
      @has_topics_enabled = nil,
      @allows_users_to_create_topics = nil,
      @can_manage_bots = nil,
    )
    end
  end
end
