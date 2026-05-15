module TelegramBot
  class RefundedPayment
    include JSON::Serializable

    property currency : String
    property total_amount : Int32
    property invoice_payload : String
    property telegram_payment_charge_id : String
    property provider_payment_charge_id : String?
  end

  class StarAmount
    include JSON::Serializable

    property amount : Int32
    property nanostar_amount : Int32?
  end

  class RevenueWithdrawalState
    include JSON::Serializable

    property type : String
    property date : Int32?
    property url : String?
  end

  class AffiliateInfo
    include JSON::Serializable

    property affiliate_user : User?
    property affiliate_chat : Chat?
    property commission_per_mille : Int32
    property amount : Int32
    property nanostar_amount : Int32?
  end

  class TransactionPartner
    include JSON::Serializable

    property type : String
    property transaction_type : String?
    property user : User?
    property chat : Chat?
    property affiliate : AffiliateInfo?
    property invoice_payload : String?
    property subscription_period : Int32?
    property paid_media : Array(PaidMedia)?
    property paid_media_payload : String?
    property gift : JSON::Any?
    property premium_subscription_duration : Int32?
    property sponsor_user : User?
    property commission_per_mille : Int32?
    property withdrawal_state : RevenueWithdrawalState?
    property request_count : Int32?
  end

  class StarTransaction
    include JSON::Serializable

    property id : String
    property amount : Int32
    property nanostar_amount : Int32?
    property date : Int32
    property source : TransactionPartner?
    property receiver : TransactionPartner?
  end

  class StarTransactions
    include JSON::Serializable

    property transactions : Array(StarTransaction)
  end
end
