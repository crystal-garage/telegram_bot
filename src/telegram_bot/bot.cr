require "http/client"
require "http/server"
require "json"
require "log"
require "./fiber.cr"
require "./types/inline/*"
require "./types/*"

require "./http_client_multipart.cr"
require "./http_client.cr"
require "./response_client.cr"
require "./api_exception.cr"

module TelegramBot
  abstract class Bot
    Log = ::Log.for(self)

    def initialize(
      @name : String,
      @token : String,
      @allowlist : Array(String)? = nil,
      @blocklist : Array(String)? = nil,
      @updates_timeout : Int32? = nil,
      @allowed_updates : Array(String)? = nil,
    )
      @nextoffset = 0
      @running = false
    end
  end
end

require "./bot/requests"
require "./bot/updates"
require "./bot/methods/sending"
require "./bot/methods/chat"
require "./bot/methods/inline"
require "./bot/methods/files"
require "./bot/methods/webhooks"
require "./bot/methods/gifts_business"
require "./bot/methods/games"
require "./bot/methods/payments"
require "./bot/methods/stickers"
require "./bot/methods/profile"
