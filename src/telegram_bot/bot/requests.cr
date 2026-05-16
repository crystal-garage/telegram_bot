module TelegramBot
  class Bot
    # :nodoc:
    protected def request(
      method : String,
      force_http : Bool = false,
      params : Hash = {} of String => String | Int32?,
    )
      client =
        if !force_http && (context = Fiber.current.telegram_bot_server_http_context)
          ResponseClient.new(context.not_nil!.response) ensure Fiber.current.telegram_bot_server_http_context = nil
        else
          HttpClient.new(@token)
        end

      serialized_params = serialize_params(params)

      response =
        if serialized_params.values.any?(::File)
          multipart_params = HTTP::Client::MultipartBody.new(serialized_params)
          client.post_multipart method, multipart_params
        elsif !serialized_params.empty?
          form_params = serialized_params.reduce(Hash(String, String).new) { |h, (k, v)| h[k] = v.to_s; h }
          client.post_form method, form_params
        else
          client.post method
        end

      client.close

      return if response.nil?

      handle_http_response(response)
    end

    # :nodoc:
    protected def serialize_params(params : Hash) : Hash(String, String | ::File)
      params.reduce(Hash(String, String | ::File).new) do |serialized, (key, value)|
        serialized[key] = serialize_param(value) unless value.nil?

        serialized
      end
    end

    # :nodoc:
    protected def serialize_param(value : ::File) : ::File
      value
    end

    # :nodoc:
    protected def serialize_param(value : String) : String
      value
    end

    # :nodoc:
    protected def serialize_param(value : Bool) : String
      value.to_s
    end

    # :nodoc:
    protected def serialize_param(value : Number) : String
      value.to_s
    end

    # :nodoc:
    protected def serialize_param(value : Array) : String
      value.to_json
    end

    # :nodoc:
    protected def serialize_param(value) : String
      value.to_json
    end

    # :nodoc:
    protected def handle_http_response(response)
      if response.status_code == 200
        json = JSON.parse(response.body)

        if json["ok"]
          json["result"]
        else
          raise APIException.new(200, json)
        end
      else
        json = begin
          JSON.parse(response.body)
        rescue JSON::ParseException
          nil
        end

        raise APIException.new(response.status_code, json)
      end
    end

    # Returns basic information about the bot.
    #
    # See: <https://core.telegram.org/bots/api#getme>
    def get_me
      request("getMe", force_http: true)
    end

    # Receives incoming updates using long polling.
    #
    # See: <https://core.telegram.org/bots/api#getupdates>
    private def get_updates(
      offset = @nextoffset,
      limit : Int32? = nil,
      timeout : Int32? = @updates_timeout,
      allowed_updates : Array(String)? = @allowed_updates,
    )
      data = request(
        "getUpdates",
        force_http: true,
        params: {"offset" => offset, "limit" => limit, "timeout" => timeout, "allowed_updates" => allowed_updates}
      ).not_nil!

      r = [] of Update
      data.as_a.each do |json|
        r << Update.from_json(json.to_json)
      end

      unless r.empty?
        @nextoffset = r.last.update_id + 1
      end

      r
    end

    # :nodoc:
    macro def_request(name, *args)
      params = {
        {% for arg in args %}
          {{ arg.stringify }} => {{ arg.id }},
        {% end %}
      }

      request({{ name }}, force_http: false, params: params)
    end

    # :nodoc:
    macro def_force_request(name, *args)
      params = {
        {% for arg in args %}
          {{ arg.stringify }} => {{ arg.id }},
        {% end %}
      }

      request({{ name }}, force_http: true, params: params)
    end

    alias ReplyMarkup = InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply?
  end
end
