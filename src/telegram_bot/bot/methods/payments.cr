module TelegramBot
  class Bot
    # Sends invoices.
    #
    # See: <https://core.telegram.org/bots/api#sendinvoice>
    def send_invoice(
      chat_id : Int | String,
      title : String,
      description : String,
      payload : String,
      provider_token : String,
      start_parameter : String,
      currency : String,
      prices : Array(LabeledPrice),
      business_connection_id : String? = nil,
      message_thread_id : Int32? = nil,
      direct_messages_topic_id : Int64? = nil,
      subscription_period : Int32? = nil,
      max_tip_amount : Int32? = nil,
      suggested_tip_amounts : Array(Int32)? = nil,
      provider_data : String? = nil,
      photo_url : String? = nil,
      photo_size : Int32? = nil,
      photo_width : Int32? = nil,
      photo_height : Int32? = nil,
      need_name : Bool? = nil,
      need_phone_number : Bool? = nil,
      need_email : Bool? = nil,
      need_shipping_address : Bool? = nil,
      send_phone_number_to_provider : Bool? = nil,
      send_email_to_provider : Bool? = nil,
      is_flexible : Bool? = nil,
      disable_notification : Bool? = nil,
      protect_content : Bool? = nil,
      allow_paid_broadcast : Bool? = nil,
      message_effect_id : String? = nil,
      suggested_post_parameters : SuggestedPostParameters? = nil,
      reply_parameters : ReplyParameters? = nil,
      reply_markup : InlineKeyboardMarkup? = nil,
    ) : Message?
      res = def_request(
        "sendInvoice",
        business_connection_id,
        chat_id,
        message_thread_id,
        direct_messages_topic_id,
        title,
        description,
        payload,
        provider_token,
        currency,
        prices,
        subscription_period,
        max_tip_amount,
        suggested_tip_amounts,
        start_parameter,
        provider_data,
        photo_url,
        photo_size,
        photo_width,
        photo_height,
        need_name,
        need_phone_number,
        need_email,
        need_shipping_address,
        send_phone_number_to_provider,
        send_email_to_provider,
        is_flexible,
        disable_notification,
        protect_content,
        allow_paid_broadcast,
        message_effect_id,
        suggested_post_parameters,
        reply_parameters,
        reply_markup)

      Message.from_json(res.to_json) if res
    end

    # Creates a link for an invoice.
    #
    # See: <https://core.telegram.org/bots/api#createinvoicelink>
    def create_invoice_link(
      title : String,
      description : String,
      payload : String,
      currency : String,
      prices : Array(LabeledPrice),
      business_connection_id : String? = nil,
      provider_token : String? = nil,
      subscription_period : Int32? = nil,
      max_tip_amount : Int32? = nil,
      suggested_tip_amounts : Array(Int32)? = nil,
      provider_data : String? = nil,
      photo_url : String? = nil,
      photo_size : Int32? = nil,
      photo_width : Int32? = nil,
      photo_height : Int32? = nil,
      need_name : Bool? = nil,
      need_phone_number : Bool? = nil,
      need_email : Bool? = nil,
      need_shipping_address : Bool? = nil,
      send_phone_number_to_provider : Bool? = nil,
      send_email_to_provider : Bool? = nil,
      is_flexible : Bool? = nil,
    ) : String
      res = def_force_request(
        "createInvoiceLink",
        business_connection_id,
        title,
        description,
        payload,
        provider_token,
        currency,
        prices,
        subscription_period,
        max_tip_amount,
        suggested_tip_amounts,
        provider_data,
        photo_url,
        photo_size,
        photo_width,
        photo_height,
        need_name,
        need_phone_number,
        need_email,
        need_shipping_address,
        send_phone_number_to_provider,
        send_email_to_provider,
        is_flexible
      )

      res.as_s
    end

    # Sends an answer to a shipping query.
    #
    # See: <https://core.telegram.org/bots/api#answershippingquery>
    def answer_shipping_query(
      shipping_query_id : String,
      ok : Bool,
      shipping_options : Array(ShippingOption)? = nil,
      error_message : String? = nil,
    ) : Bool?
      res = def_request(
        "answerShippingQuery",
        shipping_query_id,
        ok,
        shipping_options,
        error_message
      )

      res.as_bool if res
    end

    # Sends an answer to a pre-checkout query.
    #
    # See: <https://core.telegram.org/bots/api#answerprecheckoutquery>
    def answer_pre_checkout_query(
      pre_checkout_query_id : String,
      ok : Bool,
      error_message : String? = nil,
    ) : Bool?
      res = def_request(
        "answerPreCheckoutQuery",
        pre_checkout_query_id,
        ok,
        error_message
      )

      res.as_bool if res
    end

    # Returns the bot's Telegram Star balance.
    #
    # See: <https://core.telegram.org/bots/api#getmystarbalance>
    def get_my_star_balance : StarAmount
      res = request(
        "getMyStarBalance",
        force_http: true
      )

      StarAmount.from_json(res.to_json)
    end

    # Returns the bot's Telegram Star transactions.
    #
    # See: <https://core.telegram.org/bots/api#getstartransactions>
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

    # Refunds a Telegram Star payment.
    #
    # See: <https://core.telegram.org/bots/api#refundstarpayment>
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

    # Edits a user's Telegram Star subscription.
    #
    # See: <https://core.telegram.org/bots/api#edituserstarsubscription>
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

    # Reports validation errors in submitted Telegram Passport data.
    #
    # See: <https://core.telegram.org/bots/api#setpassportdataerrors>
    def set_passport_data_errors(
      user_id : Int,
      errors : Array(PassportElementError),
    )
      res = def_force_request(
        "setPassportDataErrors",
        user_id,
        errors
      )

      res.as_bool if res
    end
  end
end
