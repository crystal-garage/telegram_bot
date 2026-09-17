module TelegramBot
  abstract class InputRichBlock
    include JSON::Serializable

    use_json_discriminator "type", {
      paragraph:               InputRichBlockParagraph,
      heading:                 InputRichBlockSectionHeading,
      pre:                     InputRichBlockPreformatted,
      footer:                  InputRichBlockFooter,
      divider:                 InputRichBlockDivider,
      mathematical_expression: InputRichBlockMathematicalExpression,
      anchor:                  InputRichBlockAnchor,
      list:                    InputRichBlockList,
      blockquote:              InputRichBlockBlockQuotation,
      expandable_blockquote:   InputRichBlockExpandableBlockQuotation,
      pullquote:               InputRichBlockPullQuotation,
      collage:                 InputRichBlockCollage,
      slideshow:               InputRichBlockSlideshow,
      table:                   InputRichBlockTable,
      details:                 InputRichBlockDetails,
      map:                     InputRichBlockMap,
      buttons:                 InputRichBlockButtons,
      animation:               InputRichBlockAnimation,
      audio:                   InputRichBlockAudio,
      document:                InputRichBlockDocument,
      photo:                   InputRichBlockPhoto,
      video:                   InputRichBlockVideo,
      voice_note:              InputRichBlockVoiceNote,
      thinking:                InputRichBlockThinking,
    }

    property type : String
  end

  class InputRichBlockListItem
    include JSON::Serializable

    property blocks : Array(InputRichBlock)
    property? has_checkbox : Bool?
    property? is_checked : Bool?
    property value : Int32?
    property type : String?

    def initialize(
      @blocks : Array(InputRichBlock),
      *,
      @has_checkbox : Bool? = nil,
      @is_checked : Bool? = nil,
      @value : Int32? = nil,
      @type : String? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@blocks, attachments)
    end
  end

  class InputRichBlockParagraph < InputRichBlock
    include JSON::Serializable

    property type : String = "paragraph"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class InputRichBlockSectionHeading < InputRichBlock
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

  class InputRichBlockPreformatted < InputRichBlock
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

  class InputRichBlockFooter < InputRichBlock
    include JSON::Serializable

    property type : String = "footer"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class InputRichBlockDivider < InputRichBlock
    include JSON::Serializable

    property type : String = "divider"

    def initialize
    end
  end

  class InputRichBlockMathematicalExpression < InputRichBlock
    include JSON::Serializable

    property type : String = "mathematical_expression"
    property expression : String

    def initialize(
      @expression : String,
    )
    end
  end

  class InputRichBlockAnchor < InputRichBlock
    include JSON::Serializable

    property type : String = "anchor"
    property name : String

    def initialize(
      @name : String,
    )
    end
  end

  class InputRichBlockList < InputRichBlock
    include JSON::Serializable

    property type : String = "list"
    property items : Array(InputRichBlockListItem)

    def initialize(
      @items : Array(InputRichBlockListItem),
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@items, attachments)
    end
  end

  class InputRichBlockBlockQuotation < InputRichBlock
    include JSON::Serializable

    property type : String = "blockquote"
    property blocks : Array(InputRichBlock)
    property credit : RichText?

    def initialize(
      @blocks : Array(InputRichBlock),
      *,
      @credit : RichText? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@blocks, attachments)
    end
  end

  class InputRichBlockExpandableBlockQuotation < InputRichBlock
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

  class InputRichBlockPullQuotation < InputRichBlock
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

  class InputRichBlockCollage < InputRichBlock
    include JSON::Serializable

    property type : String = "collage"
    property blocks : Array(InputRichBlock)
    property caption : RichBlockCaption?

    def initialize(
      @blocks : Array(InputRichBlock),
      *,
      @caption : RichBlockCaption? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@blocks, attachments)
    end
  end

  class InputRichBlockSlideshow < InputRichBlock
    include JSON::Serializable

    property type : String = "slideshow"
    property blocks : Array(InputRichBlock)
    property caption : RichBlockCaption?

    def initialize(
      @blocks : Array(InputRichBlock),
      *,
      @caption : RichBlockCaption? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@blocks, attachments)
    end
  end

  class InputRichBlockTable < InputRichBlock
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

  class InputRichBlockDetails < InputRichBlock
    include JSON::Serializable

    property type : String = "details"
    property summary : RichText
    property blocks : Array(InputRichBlock)
    property? is_open : Bool?

    def initialize(
      @summary : RichText,
      @blocks : Array(InputRichBlock),
      *,
      @is_open : Bool? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@blocks, attachments)
    end
  end

  class InputRichBlockMap < InputRichBlock
    include JSON::Serializable

    property type : String = "map"
    property location : Location
    property zoom : Int32?
    property width : Int32?
    property height : Int32?
    property caption : RichBlockCaption?

    def initialize(
      @location : Location,
      *,
      @zoom : Int32? = nil,
      @width : Int32? = nil,
      @height : Int32? = nil,
      @caption : RichBlockCaption? = nil,
    )
    end
  end

  class InputRichBlockButtons < InputRichBlock
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

  class InputRichBlockAnimation < InputRichBlock
    include JSON::Serializable

    property type : String = "animation"
    property animation : InputMediaAnimation
    property caption : RichBlockCaption?

    def initialize(
      @animation : InputMediaAnimation,
      *,
      @caption : RichBlockCaption? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@animation, attachments)
    end
  end

  class InputRichBlockAudio < InputRichBlock
    include JSON::Serializable

    property type : String = "audio"
    property audio : InputMediaAudio
    property caption : RichBlockCaption?

    def initialize(
      @audio : InputMediaAudio,
      *,
      @caption : RichBlockCaption? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@audio, attachments)
    end
  end

  class InputRichBlockDocument < InputRichBlock
    include JSON::Serializable

    property type : String = "document"
    property document : InputMediaDocument
    property caption : RichBlockCaption?

    def initialize(
      @document : InputMediaDocument,
      *,
      @caption : RichBlockCaption? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@document, attachments)
    end
  end

  class InputRichBlockPhoto < InputRichBlock
    include JSON::Serializable

    property type : String = "photo"
    property photo : InputMediaPhoto
    property caption : RichBlockCaption?

    def initialize(
      @photo : InputMediaPhoto,
      *,
      @caption : RichBlockCaption? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@photo, attachments)
    end
  end

  class InputRichBlockVideo < InputRichBlock
    include JSON::Serializable

    property type : String = "video"
    property video : InputMediaVideo
    property caption : RichBlockCaption?

    def initialize(
      @video : InputMediaVideo,
      *,
      @caption : RichBlockCaption? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@video, attachments)
    end
  end

  class InputRichBlockVoiceNote < InputRichBlock
    include JSON::Serializable

    property type : String = "voice_note"
    property voice_note : InputMediaVoiceNote
    property caption : RichBlockCaption?

    def initialize(
      @voice_note : InputMediaVoiceNote,
      *,
      @caption : RichBlockCaption? = nil,
    )
    end

    def collect_attachments(attachments : Hash(String, String | ::File)) : Nil
      TelegramBot.collect_attachment(@voice_note, attachments)
    end
  end

  class InputRichBlockThinking < InputRichBlock
    include JSON::Serializable

    property type : String = "thinking"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end
end
