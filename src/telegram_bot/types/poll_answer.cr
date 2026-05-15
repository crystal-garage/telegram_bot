module TelegramBot
  class PollAnswer
    include JSON::Serializable

    property poll_id : String?
    property voter_chat : Chat?
    property user : User?
    property option_ids : Array(Int32)?
    property option_persistent_ids : Array(String)?
  end
end
