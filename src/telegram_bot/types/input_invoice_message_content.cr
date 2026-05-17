module TelegramBot
  class InputInvoiceMessageContent < InputMessageContent
    include JSON::Serializable

    property title : String
    property description : String
    property payload : String
    property provider_token : String?
    property currency : String
    property prices : Array(LabeledPrice)
    property max_tip_amount : Int32?
    property suggested_tip_amounts : Array(Int32)?
    property provider_data : String?
    property photo_url : String?
    property photo_size : Int32?
    property photo_width : Int32?
    property photo_height : Int32?
    property? need_name : Bool?
    property? need_phone_number : Bool?
    property? need_email : Bool?
    property? need_shipping_address : Bool?
    property? send_phone_number_to_provider : Bool?
    property? send_email_to_provider : Bool?
    property? is_flexible : Bool?

    def initialize(
      @title : String,
      @description : String,
      @payload : String,
      @currency : String,
      @prices : Array(LabeledPrice),
      *,
      @provider_token : String? = nil,
      @max_tip_amount : Int32? = nil,
      @suggested_tip_amounts : Array(Int32)? = nil,
      @provider_data : String? = nil,
      @photo_url : String? = nil,
      @photo_size : Int32? = nil,
      @photo_width : Int32? = nil,
      @photo_height : Int32? = nil,
      @need_name : Bool? = nil,
      @need_phone_number : Bool? = nil,
      @need_email : Bool? = nil,
      @need_shipping_address : Bool? = nil,
      @send_phone_number_to_provider : Bool? = nil,
      @send_email_to_provider : Bool? = nil,
      @is_flexible : Bool? = nil,
    )
    end
  end
end
