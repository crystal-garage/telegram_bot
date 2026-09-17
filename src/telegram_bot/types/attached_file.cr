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

  def self.collect_attachment(value : Array, attachments : Hash(String, String | ::File)) : Nil
    value.each { |item| collect_attachment(item, attachments) }
  end

  def self.collect_attachment(value, attachments : Hash(String, String | ::File)) : Nil
    value.collect_attachments(attachments) if value.responds_to?(:collect_attachments)
  end
end
