module TelegramBot
  class PassportData
    include JSON::Serializable

    property data : Array(EncryptedPassportElement)
    property credentials : EncryptedCredentials
  end

  class PassportFile
    include JSON::Serializable

    property file_id : String
    property file_unique_id : String
    property file_size : Int64
    property file_date : Int32
  end

  class EncryptedPassportElement
    include JSON::Serializable

    property type : String
    property data : String?
    property phone_number : String?
    property email : String?
    property files : Array(PassportFile)?
    property front_side : PassportFile?
    property reverse_side : PassportFile?
    property selfie : PassportFile?
    property translation : Array(PassportFile)?
    property hash : String
  end

  class EncryptedCredentials
    include JSON::Serializable

    property data : String
    property hash : String
    property secret : String
  end
end
