module TelegramBot
  abstract class Bot
    def send_invoice(
      chat_id : Int,
      title : String,
      description : String,
      payload : String,
      provider_token : String,
      start_parameter : String,
      currency : String,
      prices : Array(LabeledPrice),
      provider_data : String? = nil,
      photo_url : String? = nil,
      photo_size : Int32? = nil,
      photo_width : Int32? = nil,
      photo_height : Int32? = nil,
      need_name : Bool? = nil,
      need_phone_number : Bool? = nil,
      need_email : Bool? = nil,
      need_shipping_address : Bool? = nil,
      is_flexible : Bool? = nil,
      disable_notification : Bool? = nil,
      reply_markup : ReplyMarkup = nil,
    ) : Message?
      res = def_request(
        "sendInvoice",
        chat_id,
        title,
        description,
        payload,
        provider_token,
        start_parameter,
        currency,
        prices,
        photo_url,
        photo_size,
        photo_width,
        photo_height,
        need_name,
        need_phone_number,
        need_email,
        need_shipping_address,
        is_flexible,
        disable_notification,
        reply_markup)

      Message.from_json(res.to_json) if res
    end

    def answer_shipping_query(
      shipping_query_id : String,
      ok : Bool,
      shipping_options : Array(ShippingOption)? = nil,
      error_message : String? = nil,
    ) : Bool | Message?
      res = def_request(
        "answerShippingQuery",
        shipping_query_id,
        ok,
        shipping_options,
        error_message
      )

      res.as_bool if res
    end

    def answer_pre_checkout_query(
      pre_checkout_query_id : String,
      ok : Bool,
      error_message : String? = nil,
    ) : Bool | Message?
      res = def_request(
        "answerPreCheckoutQuery",
        pre_checkout_query_id,
        ok,
        error_message
      )

      res.as_bool if res
    end

    def get_my_star_balance : StarAmount
      res = request(
        "getMyStarBalance",
        force_http: true
      )

      StarAmount.from_json(res.to_json)
    end

    def get_star_transactions(
      offset : Int32? = nil,
      limit : Int32? = nil,
    ) : StarTransactions
      res = def_force_request(
        "getStarTransactions",
        offset,
        limit
      )

      StarTransactions.from_json(res.to_json)
    end

    def refund_star_payment(
      user_id : Int,
      telegram_payment_charge_id : String,
    )
      res = def_force_request(
        "refundStarPayment",
        user_id,
        telegram_payment_charge_id
      )

      res.as_bool if res
    end

    def edit_user_star_subscription(
      user_id : Int,
      telegram_payment_charge_id : String,
      is_canceled : Bool,
    )
      res = def_force_request(
        "editUserStarSubscription",
        user_id,
        telegram_payment_charge_id,
        is_canceled
      )

      res.as_bool if res
    end
  end
end
