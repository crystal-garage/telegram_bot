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

  abstract class RevenueWithdrawalState
    include JSON::Serializable

    use_json_discriminator "type", {
      pending:   RevenueWithdrawalStatePending,
      succeeded: RevenueWithdrawalStateSucceeded,
      failed:    RevenueWithdrawalStateFailed,
    }

    property type : String
  end

  class RevenueWithdrawalStatePending < RevenueWithdrawalState
    include JSON::Serializable
  end

  class RevenueWithdrawalStateSucceeded < RevenueWithdrawalState
    include JSON::Serializable

    property type : String
    property date : Int32
    property url : String
  end

  class RevenueWithdrawalStateFailed < RevenueWithdrawalState
    include JSON::Serializable

    property type : String
  end

  abstract class TransactionPartner
    include JSON::Serializable

    use_json_discriminator "type", {
      user:              TransactionPartnerUser,
      chat:              TransactionPartnerChat,
      affiliate_program: TransactionPartnerAffiliateProgram,
      fragment:          TransactionPartnerFragment,
      telegram_ads:      TransactionPartnerTelegramAds,
      telegram_api:      TransactionPartnerTelegramApi,
      other:             TransactionPartnerOther,
    }

    property type : String
  end

  class TransactionPartnerUser < TransactionPartner
    include JSON::Serializable

    property type : String
    property transaction_type : String
    property user : User
    property affiliate : AffiliateInfo?
    property invoice_payload : String?
    property subscription_period : Int32?
    property paid_media : Array(PaidMedia)?
    property paid_media_payload : String?
    property gift : Gift?
    property premium_subscription_duration : Int32?
  end

  class TransactionPartnerChat < TransactionPartner
    include JSON::Serializable

    property type : String
    property chat : Chat
    property gift : Gift?
  end

  class TransactionPartnerAffiliateProgram < TransactionPartner
    include JSON::Serializable

    property type : String
    property sponsor_user : User?
    property commission_per_mille : Int32
  end

  class TransactionPartnerFragment < TransactionPartner
    include JSON::Serializable

    property type : String
    property withdrawal_state : RevenueWithdrawalState?
  end

  class TransactionPartnerTelegramAds < TransactionPartner
    include JSON::Serializable

    property type : String
  end

  class TransactionPartnerTelegramApi < TransactionPartner
    include JSON::Serializable

    property type : String
    property request_count : Int32
  end

  class TransactionPartnerOther < TransactionPartner
    include JSON::Serializable

    property type : String
  end

  class AffiliateInfo
    include JSON::Serializable

    property affiliate_user : User?
    property affiliate_chat : Chat?
    property commission_per_mille : Int32
    property amount : Int32
    property nanostar_amount : Int32?
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
