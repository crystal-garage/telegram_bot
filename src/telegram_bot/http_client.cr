require "http/client"

module TelegramBot
  class HttpClient
    def initialize(@token : String)
      uri = URI.parse("https://api.telegram.org")
      @client = HTTP::Client.new(uri)
      @client.dns_timeout = 5.seconds
      @client.connect_timeout = 5.seconds
    end

    def post(method : String)
      @client.post(url_for(method))
    end

    def post_form(method : String, params : Hash)
      @client.post(url_for(method), form: params)
    end

    def post_multipart(method : String, params)
      @client.post_multipart(url_for(method), params)
    end

    def close
      @client.close
    end

    protected def url_for(method) : String
      "/bot#{@token}/#{method}"
    end
  end
end
