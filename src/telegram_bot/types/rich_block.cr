module TelegramBot
  abstract class RichBlock
    include JSON::Serializable

    use_json_discriminator "type", {
      paragraph:               RichBlockParagraph,
      heading:                 RichBlockSectionHeading,
      pre:                     RichBlockPreformatted,
      footer:                  RichBlockFooter,
      divider:                 RichBlockDivider,
      mathematical_expression: RichBlockMathematicalExpression,
      anchor:                  RichBlockAnchor,
      list:                    RichBlockList,
      blockquote:              RichBlockBlockQuotation,
      expandable_blockquote:   RichBlockExpandableBlockQuotation,
      pullquote:               RichBlockPullQuotation,
      collage:                 RichBlockCollage,
      slideshow:               RichBlockSlideshow,
      table:                   RichBlockTable,
      details:                 RichBlockDetails,
      map:                     RichBlockMap,
      buttons:                 RichBlockButtons,
      animation:               RichBlockAnimation,
      audio:                   RichBlockAudio,
      document:                RichBlockDocument,
      photo:                   RichBlockPhoto,
      video:                   RichBlockVideo,
      voice_note:              RichBlockVoiceNote,
      thinking:                RichBlockThinking,
    }

    property type : String
  end

  class RichBlockCaption
    include JSON::Serializable

    property text : RichText
    property credit : RichText?

    def initialize(
      @text : RichText,
      *,
      @credit : RichText? = nil,
    )
    end
  end

  class RichBlockTableCell
    include JSON::Serializable

    property text : RichText?
    property? is_header : Bool?
    property colspan : Int32?
    property rowspan : Int32?
    property align : String
    property valign : String

    def initialize(
      @align : String,
      @valign : String,
      *,
      @text : RichText? = nil,
      @is_header : Bool? = nil,
      @colspan : Int32? = nil,
      @rowspan : Int32? = nil,
    )
    end
  end

  class RichBlockListItem
    include JSON::Serializable

    property label : String
    property blocks : Array(RichBlock)
    property? has_checkbox : Bool?
    property? is_checked : Bool?
    property value : Int32?
    property type : String?

    def initialize(
      @label : String,
      @blocks : Array(RichBlock),
      *,
      @has_checkbox : Bool? = nil,
      @is_checked : Bool? = nil,
      @value : Int32? = nil,
      @type : String? = nil,
    )
    end
  end

  class RichBlockParagraph < RichBlock
    include JSON::Serializable

    property type : String = "paragraph"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichBlockSectionHeading < RichBlock
    include JSON::Serializable

    property type : String = "heading"
    property text : RichText
    property size : Int32

    def initialize(
      @text : RichText,
      @size : Int32,
    )
    end
  end

  class RichBlockPreformatted < RichBlock
    include JSON::Serializable

    property type : String = "pre"
    property text : RichText
    property language : String?

    def initialize(
      @text : RichText,
      *,
      @language : String? = nil,
    )
    end
  end

  class RichBlockFooter < RichBlock
    include JSON::Serializable

    property type : String = "footer"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichBlockDivider < RichBlock
    include JSON::Serializable

    property type : String = "divider"

    def initialize
    end
  end

  class RichBlockMathematicalExpression < RichBlock
    include JSON::Serializable

    property type : String = "mathematical_expression"
    property expression : String

    def initialize(
      @expression : String,
    )
    end
  end

  class RichBlockAnchor < RichBlock
    include JSON::Serializable

    property type : String = "anchor"
    property name : String

    def initialize(
      @name : String,
    )
    end
  end

  class RichBlockList < RichBlock
    include JSON::Serializable

    property type : String = "list"
    property items : Array(RichBlockListItem)

    def initialize(
      @items : Array(RichBlockListItem),
    )
    end
  end

  class RichBlockBlockQuotation < RichBlock
    include JSON::Serializable

    property type : String = "blockquote"
    property blocks : Array(RichBlock)
    property credit : RichText?

    def initialize(
      @blocks : Array(RichBlock),
      *,
      @credit : RichText? = nil,
    )
    end
  end

  class RichBlockExpandableBlockQuotation < RichBlock
    include JSON::Serializable

    property type : String = "expandable_blockquote"
    property text : RichText
    property credit : RichText?

    def initialize(
      @text : RichText,
      *,
      @credit : RichText? = nil,
    )
    end
  end

  class RichBlockPullQuotation < RichBlock
    include JSON::Serializable

    property type : String = "pullquote"
    property text : RichText
    property credit : RichText?

    def initialize(
      @text : RichText,
      *,
      @credit : RichText? = nil,
    )
    end
  end

  class RichBlockCollage < RichBlock
    include JSON::Serializable

    property type : String = "collage"
    property blocks : Array(RichBlock)
    property caption : RichBlockCaption?

    def initialize(
      @blocks : Array(RichBlock),
      *,
      @caption : RichBlockCaption? = nil,
    )
    end
  end

  class RichBlockSlideshow < RichBlock
    include JSON::Serializable

    property type : String = "slideshow"
    property blocks : Array(RichBlock)
    property caption : RichBlockCaption?

    def initialize(
      @blocks : Array(RichBlock),
      *,
      @caption : RichBlockCaption? = nil,
    )
    end
  end

  class RichBlockTable < RichBlock
    include JSON::Serializable

    property type : String = "table"
    property cells : Array(Array(RichBlockTableCell))
    property? is_bordered : Bool?
    property? is_striped : Bool?
    property? is_compact : Bool?
    property caption : RichText?

    def initialize(
      @cells : Array(Array(RichBlockTableCell)),
      *,
      @is_bordered : Bool? = nil,
      @is_striped : Bool? = nil,
      @is_compact : Bool? = nil,
      @caption : RichText? = nil,
    )
    end
  end

  class RichBlockDetails < RichBlock
    include JSON::Serializable

    property type : String = "details"
    property summary : RichText
    property blocks : Array(RichBlock)
    property? is_open : Bool?

    def initialize(
      @summary : RichText,
      @blocks : Array(RichBlock),
      *,
      @is_open : Bool? = nil,
    )
    end
  end

  class RichBlockMap < RichBlock
    include JSON::Serializable

    property type : String = "map"
    property location : Location
    property zoom : Int32
    property width : Int32
    property height : Int32
    property caption : RichBlockCaption?

    def initialize(
      @location : Location,
      @zoom : Int32,
      @width : Int32,
      @height : Int32,
      *,
      @caption : RichBlockCaption? = nil,
    )
    end
  end

  class RichBlockButtons < RichBlock
    include JSON::Serializable

    property type : String = "buttons"
    property buttons : Array(RichMessageButton)
    property align : String?

    def initialize(
      @buttons : Array(RichMessageButton),
      *,
      @align : String? = nil,
    )
    end
  end

  class RichBlockAnimation < RichBlock
    include JSON::Serializable

    property type : String = "animation"
    property animation : Animation
    property? has_spoiler : Bool?
    property caption : RichBlockCaption?

    def initialize(
      @animation : Animation,
      *,
      @has_spoiler : Bool? = nil,
      @caption : RichBlockCaption? = nil,
    )
    end
  end

  class RichBlockAudio < RichBlock
    include JSON::Serializable

    property type : String = "audio"
    property audio : Audio
    property caption : RichBlockCaption?

    def initialize(
      @audio : Audio,
      *,
      @caption : RichBlockCaption? = nil,
    )
    end
  end

  class RichBlockDocument < RichBlock
    include JSON::Serializable

    property type : String = "document"
    property document : Document
    property caption : RichBlockCaption?

    def initialize(
      @document : Document,
      *,
      @caption : RichBlockCaption? = nil,
    )
    end
  end

  class RichBlockPhoto < RichBlock
    include JSON::Serializable

    property type : String = "photo"
    property photo : Array(PhotoSize)
    property? has_spoiler : Bool?
    property caption : RichBlockCaption?

    def initialize(
      @photo : Array(PhotoSize),
      *,
      @has_spoiler : Bool? = nil,
      @caption : RichBlockCaption? = nil,
    )
    end
  end

  class RichBlockVideo < RichBlock
    include JSON::Serializable

    property type : String = "video"
    property video : Video
    property? has_spoiler : Bool?
    property caption : RichBlockCaption?

    def initialize(
      @video : Video,
      *,
      @has_spoiler : Bool? = nil,
      @caption : RichBlockCaption? = nil,
    )
    end
  end

  class RichBlockVoiceNote < RichBlock
    include JSON::Serializable

    property type : String = "voice_note"
    property voice_note : Voice
    property caption : RichBlockCaption?

    def initialize(
      @voice_note : Voice,
      *,
      @caption : RichBlockCaption? = nil,
    )
    end
  end

  class RichBlockThinking < RichBlock
    include JSON::Serializable

    property type : String = "thinking"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end
end
