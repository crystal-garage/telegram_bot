module TelegramBot
  class PassportElementError
    include JSON::Serializable

    property source : String
    property type : String
    property message : String
    property field_name : String?
    property data_hash : String?
    property file_hash : String?
    property file_hashes : Array(String)?
    property element_hash : String?

    def initialize(
      @source : String,
      @type : String,
      @message : String,
      *,
      @field_name : String? = nil,
      @data_hash : String? = nil,
      @file_hash : String? = nil,
      @file_hashes : Array(String)? = nil,
      @element_hash : String? = nil,
    )
    end

    def self.data_field(type : String, field_name : String, data_hash : String, message : String)
      new("data", type, message, field_name: field_name, data_hash: data_hash)
    end

    def self.front_side(type : String, file_hash : String, message : String)
      new("front_side", type, message, file_hash: file_hash)
    end

    def self.reverse_side(type : String, file_hash : String, message : String)
      new("reverse_side", type, message, file_hash: file_hash)
    end

    def self.selfie(type : String, file_hash : String, message : String)
      new("selfie", type, message, file_hash: file_hash)
    end

    def self.file(type : String, file_hash : String, message : String)
      new("file", type, message, file_hash: file_hash)
    end

    def self.files(type : String, file_hashes : Array(String), message : String)
      new("files", type, message, file_hashes: file_hashes)
    end

    def self.translation_file(type : String, file_hash : String, message : String)
      new("translation_file", type, message, file_hash: file_hash)
    end

    def self.translation_files(type : String, file_hashes : Array(String), message : String)
      new("translation_files", type, message, file_hashes: file_hashes)
    end

    def self.unspecified(type : String, element_hash : String, message : String)
      new("unspecified", type, message, element_hash: element_hash)
    end
  end
end
