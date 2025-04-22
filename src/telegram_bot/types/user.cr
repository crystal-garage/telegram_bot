module TelegramBot
  class User
    include JSON::Serializable

    property id : Int64
    property? is_bot : Bool
    property first_name : String
    property last_name : String?
    property username : String?
    property language_code : String?
    property? can_join_groups : Bool?
    property? can_read_all_group_messages : Bool?
    property? supports_inline_queries : Bool?

    def initialize(
      @id : Int64,
      @is_bot : Bool,
      @first_name : String,
      *,
      @last_name = nil,
      @username = nil,
      @language_code = nil,
      @can_join_groups = nil,
      @can_read_all_group_messages = nil,
      @supports_inline_queries = nil,
    )
    end
  end
end
