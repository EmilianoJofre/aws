class Api::V2::UtilsController < Api::V2::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  respond_to :json

  # GET /api/v2/enums
  def get_enums
    data = {
      account_types: account_types,
      payment_cycles: payment_cycles,
      rate_types: rate_types,
      asset_types: asset_types,
      movement_types: movement_types,
      document_types: document_types
    }
    respond_with data 
  end

  private

  def account_types
    Account.account_types.keys.map do |value|
      { id: value, label: I18n.t("activerecord.attributes.accounts.account_type.#{value}") }
    end
  end

  def asset_types
    InvestmentAsset.asset_types.keys.map do |value|
      { id: value, label: I18n.t("activerecord.attributes.investment_assets.asset_type.#{value}") }
    end
  end

  def movement_types
    MoneyMovement.movement_types.keys.map do |value|
      { id: value, label: I18n.t("activerecord.attributes.money_movement.movement_type.#{value}") }
    end
  end
  
  def document_types
    RelationFile.document_types.keys.map do |value|
      { id: value, label: I18n.t("activerecord.enums.relation_file.document_types.#{value}") }
    end
  end

  def payment_cycles
    Liability.payment_cycles.keys.map do |value|
      { id: value, label: I18n.t("activerecord.attributes.liability.payment_cycle.#{value}") }
    end
  end

  def rate_types
    Liability.rate_types.keys.map do |value|
      { id: value, label: I18n.t("activerecord.attributes.liability.rate_type.#{value}") }
    end
  end
end
