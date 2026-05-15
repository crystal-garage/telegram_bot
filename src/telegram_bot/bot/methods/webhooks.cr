module TelegramBot
  abstract class Bot
    # Sets a webhook for receiving incoming updates.
    #
    # See: <https://core.telegram.org/bots/api#setwebhook>
    def set_webhook(
      url : String,
      certificate : ::File | String? = nil,
      max_connections : Int32? = nil,
      allowed_updates : Array(String)? = @allowed_updates,
      ip_address : String? = nil,
      drop_pending_updates : Bool? = nil,
      secret_token : String? = nil,
    )
      multipart_params = HTTP::Client::MultipartBody.new(serialize_params({
        "url"                  => url,
        "max_connections"      => max_connections,
        "allowed_updates"      => allowed_updates,
        "ip_address"           => ip_address,
        "drop_pending_updates" => drop_pending_updates,
        "secret_token"         => secret_token,
      }))

      multipart_params.add_file("certificate", certificate, filename: "cert.pem") if certificate
      Log.info { "Setting webhook to '#{url}'#{" with certificate" if certificate}" }
      response = HttpClient.new(@token).post_multipart "setWebhook", multipart_params

      handle_http_response(response)
    end

    # Removes webhook integration.
    #
    # See: <https://core.telegram.org/bots/api#deletewebhook>
    def delete_webhook(
      drop_pending_updates : Bool? = nil,
    ) : Bool?
      res = def_force_request(
        "deleteWebhook",
        drop_pending_updates
      )

      res.as_bool if res
    end

    # Returns current webhook status.
    #
    # See: <https://core.telegram.org/bots/api#getwebhookinfo>
    def get_webhook_info : WebhookInfo
      res = request("getWebhookInfo", force_http: true)
      WebhookInfo.from_json(res.to_json)
    end
  end
end
