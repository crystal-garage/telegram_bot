module TelegramBot
  class AttachedFile
    getter name, file

    def initialize(@name : String, @file : ::File)
    end

    def reference : String
      "attach://#{@name}"
    end

    def to_json(json : JSON::Builder)
      reference.to_json(json)
    end

    def to_s(io : IO)
      io << reference
    end
  end

  def self.collect_attachment(value : AttachedFile, attachments : Hash(String, String | ::File)) : Nil
    attachments[value.name] = value.file
  end

  def self.collect_attachment(value, attachments : Hash(String, String | ::File)) : Nil
  end
end
