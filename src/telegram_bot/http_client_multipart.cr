require "http/client"
require "http/formdata"

class HTTP::Client
  def self.post_multipart(url : String | URI, parts : MultipartBody | Hash, headers : HTTP::Headers? = nil) : HTTP::Client::Response
    exec(url) do |client, path|
      client.post_multipart(path, parts, headers)
    end
  end

  def post_multipart(path, parts : MultipartBody, headers : HTTP::Headers? = nil) : HTTP::Client::Response
    headers ||= HTTP::Headers.new
    headers["Content-Type"] = parts.content_type
    post path, headers, parts.bodyg
  end

  def post_multipart(path, params : Hash, headers : HTTP::Headers? = nil) : HTTP::Client::Response
    parts = HTTP::Client::MultipartBody.new(params)
    post_multipart(path, parts, headers)
  end

  class MultipartBody
    @body = IO::Memory.new
    @builder : HTTP::FormData::Builder
    @finished = false

    def initialize
      @builder = HTTP::FormData::Builder.new(@body)
    end

    def boundary
      @builder.boundary
    end

    def content_type
      @builder.content_type
    end

    def bodyg
      unless @finished
        @builder.finish
        @finished = true
      end

      @body.to_s
    end

    def initialize(params : Hash)
      initialize

      params.each do |k, v|
        if v.nil?
          next
        elsif v.is_a?(::File)
          add_file(k, v)
        else
          add_part(k, v.to_s)
        end
      end
    end

    def add_part(name : String, content : String, mime_type : String? = nil)
      headers = HTTP::Headers.new
      headers["Content-Type"] = mime_type if mime_type
      @builder.field(name, content, headers)
    end

    def add_file(name : String, content : String, filename : String? = nil, mime_type : String = "application/octet-stream")
      headers = HTTP::Headers{"Content-Type" => mime_type}
      metadata = HTTP::FormData::FileMetadata.new(filename: filename)
      @builder.file(name, IO::Memory.new(content), metadata, headers)
    end

    def add_file(name : String, file : ::File, filename : String? = nil, mime_type : String = "application/octet-stream")
      headers = HTTP::Headers{"Content-Type" => mime_type}
      metadata = HTTP::FormData::FileMetadata.new(filename: filename || ::File.basename(file.path))

      ::File.open(file.path) do |io|
        @builder.file(name, io, metadata, headers)
      end
    end
  end
end
