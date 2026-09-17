module TelegramBot
  abstract class PassportElementError
    def to_json(json : JSON::Builder)
      raise "PassportElementError subclasses must implement JSON serialization"
    end

    def self.data_field(type : String, field_name : String, data_hash : String, message : String)
      PassportElementErrorDataField.new(type, field_name, data_hash, message)
    end

    def self.front_side(type : String, file_hash : String, message : String)
      PassportElementErrorFrontSide.new(type, file_hash, message)
    end

    def self.reverse_side(type : String, file_hash : String, message : String)
      PassportElementErrorReverseSide.new(type, file_hash, message)
    end

    def self.selfie(type : String, file_hash : String, message : String)
      PassportElementErrorSelfie.new(type, file_hash, message)
    end

    def self.file(type : String, file_hash : String, message : String)
      PassportElementErrorFile.new(type, file_hash, message)
    end

    def self.files(type : String, file_hashes : Array(String), message : String)
      PassportElementErrorFiles.new(type, file_hashes, message)
    end

    def self.translation_file(type : String, file_hash : String, message : String)
      PassportElementErrorTranslationFile.new(type, file_hash, message)
    end

    def self.translation_files(type : String, file_hashes : Array(String), message : String)
      PassportElementErrorTranslationFiles.new(type, file_hashes, message)
    end

    def self.unspecified(type : String, element_hash : String, message : String)
      PassportElementErrorUnspecified.new(type, element_hash, message)
    end
  end

  class PassportElementErrorDataField < PassportElementError
    include JSON::Serializable

    property source : String = "data"
    property type : String
    property field_name : String
    property data_hash : String
    property message : String

    def initialize(@type : String, @field_name : String, @data_hash : String, @message : String)
    end
  end

  class PassportElementErrorFrontSide < PassportElementError
    include JSON::Serializable

    property source : String = "front_side"
    property type : String
    property file_hash : String
    property message : String

    def initialize(@type : String, @file_hash : String, @message : String)
    end
  end

  class PassportElementErrorReverseSide < PassportElementError
    include JSON::Serializable

    property source : String = "reverse_side"
    property type : String
    property file_hash : String
    property message : String

    def initialize(@type : String, @file_hash : String, @message : String)
    end
  end

  class PassportElementErrorSelfie < PassportElementError
    include JSON::Serializable

    property source : String = "selfie"
    property type : String
    property file_hash : String
    property message : String

    def initialize(@type : String, @file_hash : String, @message : String)
    end
  end

  class PassportElementErrorFile < PassportElementError
    include JSON::Serializable

    property source : String = "file"
    property type : String
    property file_hash : String
    property message : String

    def initialize(@type : String, @file_hash : String, @message : String)
    end
  end

  class PassportElementErrorFiles < PassportElementError
    include JSON::Serializable

    property source : String = "files"
    property type : String
    property file_hashes : Array(String)
    property message : String

    def initialize(@type : String, @file_hashes : Array(String), @message : String)
    end
  end

  class PassportElementErrorTranslationFile < PassportElementError
    include JSON::Serializable

    property source : String = "translation_file"
    property type : String
    property file_hash : String
    property message : String

    def initialize(@type : String, @file_hash : String, @message : String)
    end
  end

  class PassportElementErrorTranslationFiles < PassportElementError
    include JSON::Serializable

    property source : String = "translation_files"
    property type : String
    property file_hashes : Array(String)
    property message : String

    def initialize(@type : String, @file_hashes : Array(String), @message : String)
    end
  end

  class PassportElementErrorUnspecified < PassportElementError
    include JSON::Serializable

    property source : String = "unspecified"
    property type : String
    property element_hash : String
    property message : String

    def initialize(@type : String, @element_hash : String, @message : String)
    end
  end
end
