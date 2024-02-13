class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:relations]

  def index
    if current_user.present?
      redirect_to relations_path
    elsif current_relation.present?
      redirect_to relation_path(current_relation)
    else
      redirect_to new_relation_session_path
    end
  end

  def relations
    @is_demo = demo?
    @banks = banks
    @investment_assets_all = investment_assets
    @investment_assets_instruments = investment_assets_instruments
    @investment_assets_pension_funds = investment_assets_pension_funds
    @investment_assets_real_estates = investment_assets_real_estates
    @investment_assets_types = investment_assets_types
    @account_types = account_types
    @communes = communes
    @real_estate_identifiers = real_estate_identifiers
    @is_user = user_signed_in?
    @internal_id = current_user.internal_id
  end

  private

  def banks
    Bank.pluck(:id, :name).map { |bank| { id: bank[0], label: bank[1] } }
  end

  def investment_assets
    InvestmentAsset.not_custom.valid.pluck(:id, :asset_id, :currency).map do |asset|
      { id: asset[0], label: asset[1], currency: asset[2] }
    end
  end

  def investment_assets_instruments
    InvestmentAsset.not_custom.investment_instruments.valid.pluck(:id, :asset_id, :currency).map do |asset|
      { id: asset[0], label: asset[1], currency: asset[2] }
    end
  end

  def investment_assets_pension_funds
    InvestmentAsset.not_custom.pension_funds.valid.pluck(:id, :asset_id, :currency).map do |asset|
      { id: asset[0], label: asset[1], currency: asset[2] }
    end
  end

  def investment_assets_real_estates
    InvestmentAsset.not_custom.real_estates.valid.pluck(:id, :asset_id, :currency).map do |asset|
      { id: asset[0], label: asset[1], currency: asset[2] }
    end
  end

  def investment_assets_types
    InvestmentAsset.asset_types.keys.map do |value|
      { id: value, label: I18n.t("activerecord.attributes.investment_assets.asset_type.#{value}") }
    end
  end

  def account_types
    Account.account_types.keys.map do |value|
      { id: value, label: I18n.t("activerecord.attributes.accounts.account_type.#{value}") }
    end
  end

  def communes
    Commune.select(:id, :name, :code_sii, :code_tesoreria).order(name: :asc)
  end

  def real_estate_identifiers
    [
      "Casa",
      "Departamento",
      "Sitio",
      "Parcela",
      "Oficina",
      "Terreno",
      "Bodega",
      "Estacionamiento",
      "Loteo",
      "Agricola",
      "Industrial",
      "Local",
      "Otros"
    ]
  end

  def demo?
    params[:demo] == 'true'
  end
end
