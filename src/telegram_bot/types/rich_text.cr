module TelegramBot
  # Rich text can be plain text, a sequence, or a typed formatting entity.
  class RichText
    getter value : String | Array(RichText) | RichTextEntity

    def initialize(@value : String | Array(RichText) | RichTextEntity)
    end

    def initialize(pull : JSON::PullParser)
      @value = case pull.kind
               when .string?
                 pull.read_string
               when .begin_array?
                 Array(RichText).new(pull)
               else
                 RichTextEntity.new(pull)
               end
    end

    def to_json(json : JSON::Builder)
      @value.to_json(json)
    end
  end

  abstract class RichTextEntity
    include JSON::Serializable

    use_json_discriminator "type", {
      bold:                    RichTextBold,
      italic:                  RichTextItalic,
      underline:               RichTextUnderline,
      strikethrough:           RichTextStrikethrough,
      spoiler:                 RichTextSpoiler,
      date_time:               RichTextDateTime,
      text_mention:            RichTextTextMention,
      subscript:               RichTextSubscript,
      superscript:             RichTextSuperscript,
      marked:                  RichTextMarked,
      code:                    RichTextCode,
      custom_emoji:            RichTextCustomEmoji,
      mathematical_expression: RichTextMathematicalExpression,
      url:                     RichTextUrl,
      email_address:           RichTextEmailAddress,
      phone_number:            RichTextPhoneNumber,
      bank_card_number:        RichTextBankCardNumber,
      mention:                 RichTextMention,
      hashtag:                 RichTextHashtag,
      cashtag:                 RichTextCashtag,
      bot_command:             RichTextBotCommand,
      button:                  RichTextButton,
      anchor:                  RichTextAnchor,
      anchor_link:             RichTextAnchorLink,
      reference:               RichTextReference,
      reference_link:          RichTextReferenceLink,
    }

    property type : String
  end

  class RichTextBold < RichTextEntity
    include JSON::Serializable

    property type : String = "bold"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichTextItalic < RichTextEntity
    include JSON::Serializable

    property type : String = "italic"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichTextUnderline < RichTextEntity
    include JSON::Serializable

    property type : String = "underline"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichTextStrikethrough < RichTextEntity
    include JSON::Serializable

    property type : String = "strikethrough"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichTextSpoiler < RichTextEntity
    include JSON::Serializable

    property type : String = "spoiler"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichTextDateTime < RichTextEntity
    include JSON::Serializable

    property type : String = "date_time"
    property text : RichText
    property unix_time : Int32
    property date_time_format : String

    def initialize(
      @text : RichText,
      @unix_time : Int32,
      @date_time_format : String,
    )
    end
  end

  class RichTextTextMention < RichTextEntity
    include JSON::Serializable

    property type : String = "text_mention"
    property text : RichText
    property user : User

    def initialize(
      @text : RichText,
      @user : User,
    )
    end
  end

  class RichTextSubscript < RichTextEntity
    include JSON::Serializable

    property type : String = "subscript"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichTextSuperscript < RichTextEntity
    include JSON::Serializable

    property type : String = "superscript"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichTextMarked < RichTextEntity
    include JSON::Serializable

    property type : String = "marked"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichTextCode < RichTextEntity
    include JSON::Serializable

    property type : String = "code"
    property text : RichText

    def initialize(
      @text : RichText,
    )
    end
  end

  class RichTextCustomEmoji < RichTextEntity
    include JSON::Serializable

    property type : String = "custom_emoji"
    property custom_emoji_id : String
    property alternative_text : String

    def initialize(
      @custom_emoji_id : String,
      @alternative_text : String,
    )
    end
  end

  class RichTextMathematicalExpression < RichTextEntity
    include JSON::Serializable

    property type : String = "mathematical_expression"
    property expression : String

    def initialize(
      @expression : String,
    )
    end
  end

  class RichTextUrl < RichTextEntity
    include JSON::Serializable

    property type : String = "url"
    property text : RichText
    property url : String

    def initialize(
      @text : RichText,
      @url : String,
    )
    end
  end

  class RichTextEmailAddress < RichTextEntity
    include JSON::Serializable

    property type : String = "email_address"
    property text : RichText
    property email_address : String

    def initialize(
      @text : RichText,
      @email_address : String,
    )
    end
  end

  class RichTextPhoneNumber < RichTextEntity
    include JSON::Serializable

    property type : String = "phone_number"
    property text : RichText
    property phone_number : String

    def initialize(
      @text : RichText,
      @phone_number : String,
    )
    end
  end

  class RichTextBankCardNumber < RichTextEntity
    include JSON::Serializable

    property type : String = "bank_card_number"
    property text : RichText
    property bank_card_number : String

    def initialize(
      @text : RichText,
      @bank_card_number : String,
    )
    end
  end

  class RichTextMention < RichTextEntity
    include JSON::Serializable

    property type : String = "mention"
    property text : RichText
    property username : String

    def initialize(
      @text : RichText,
      @username : String,
    )
    end
  end

  class RichTextHashtag < RichTextEntity
    include JSON::Serializable

    property type : String = "hashtag"
    property text : RichText
    property hashtag : String

    def initialize(
      @text : RichText,
      @hashtag : String,
    )
    end
  end

  class RichTextCashtag < RichTextEntity
    include JSON::Serializable

    property type : String = "cashtag"
    property text : RichText
    property cashtag : String

    def initialize(
      @text : RichText,
      @cashtag : String,
    )
    end
  end

  class RichTextBotCommand < RichTextEntity
    include JSON::Serializable

    property type : String = "bot_command"
    property text : RichText
    property bot_command : String

    def initialize(
      @text : RichText,
      @bot_command : String,
    )
    end
  end

  class RichTextButton < RichTextEntity
    include JSON::Serializable

    property type : String = "button"
    property button : RichMessageButton

    def initialize(
      @button : RichMessageButton,
    )
    end
  end

  class RichTextAnchor < RichTextEntity
    include JSON::Serializable

    property type : String = "anchor"
    property name : String

    def initialize(
      @name : String,
    )
    end
  end

  class RichTextAnchorLink < RichTextEntity
    include JSON::Serializable

    property type : String = "anchor_link"
    property text : RichText
    property anchor_name : String

    def initialize(
      @text : RichText,
      @anchor_name : String,
    )
    end
  end

  class RichTextReference < RichTextEntity
    include JSON::Serializable

    property type : String = "reference"
    property text : RichText
    property name : String

    def initialize(
      @text : RichText,
      @name : String,
    )
    end
  end

  class RichTextReferenceLink < RichTextEntity
    include JSON::Serializable

    property type : String = "reference_link"
    property text : RichText
    property reference_name : String

    def initialize(
      @text : RichText,
      @reference_name : String,
    )
    end
  end
end
