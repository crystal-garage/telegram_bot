module TelegramBot
  class LinkPreviewOptions
    include JSON::Serializable

    property? is_disabled : Bool?
    property url : String?
    property? prefer_small_media : Bool?
    property? prefer_large_media : Bool?
    property? show_above_text : Bool?

    def initialize(
      *,
      @is_disabled = nil,
      @url = nil,
      @prefer_small_media = nil,
      @prefer_large_media = nil,
      @show_above_text = nil,
    )
    end
  end
end
