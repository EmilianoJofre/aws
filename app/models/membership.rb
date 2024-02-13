class Membership < ApplicationRecord
  include LedgerizerAccountable

  belongs_to :sub_account
  belongs_to :investment_asset
  has_many :money_movements, dependent: :destroy
  has_many :price_change_documents, dependent: :destroy
  has_many :real_estates, dependent: :destroy
  has_many :liabilities, dependent: :destroy
  has_many :alternative_names, dependent: :destroy
  has_many :external_value_changes, dependent: :destroy
  has_many :others_memberships, dependent: :destroy
  delegate :account, :currency, to: :sub_account
  delegate :relation, to: :account
  delegate :user, to: :relation
  delegate :is_custom, to: :investment_asset
  delegate :asset_id, to: :investment_asset, prefix: false

  scope :with_custom_asset, -> {
    joins(:investment_asset).where(investment_assets: { is_custom: true })
  }
  scope :with_real_estates, -> {
    joins(:investment_asset).where(investment_assets: { asset_type: 7 })
  }
  scope :with_liabilities, -> {
    joins(:investment_asset).where(investment_assets: { asset_type: 9 })
  }
  scope :without_custom_asset, -> {
    joins(:investment_asset).where(investment_assets: { is_custom: false })
  }
  scope :active, -> { where(hidden: false) }

  # Callbacks
  before_save :update_balance

  def update_balance
    new_balance = self.balance[:CLP]
    return if new_balance == updated_balance

    self.update_columns(updated_balance: self.balance[:CLP], status: 'updated')
    sub_account.update_balance
    account.update_balance
  end

  def name
    "#{sub_account_id} - #{investment_asset_id}"
  end

  def quotas_balance(date = Time.current)
    accounts.find_by(name: 'quotas')&.balance_at(date)&.amount
  end

  def amount_invested_balance(date = Time.current)
    accounts.find_by(name: 'amount_invested')&.balance_at(date)&.amount
  end

  def amount_updated_balance(date = Time.current)
    accounts.find_by(name: 'amount_updated')&.balance_at(date)&.amount
  end

  def incomes_balance(date = Time.current)
    accounts.find_by(name: 'investment_incomes')&.balance_at(date)&.amount
  end

  def quota_average_price(date = Time.current)
    date_quotas_balance = quotas_balance(date)
    return 0 if date_quotas_balance.nil? || date_quotas_balance.zero?

    amount_invested_balance(date) / date_quotas_balance
  end

  def updated_quota_average_price(date = Time.current)
    date_quotas_balance = quotas_balance(date)
    return 0 if date_quotas_balance.nil? || date_quotas_balance.zero?

    amount_updated_balance(date) / date_quotas_balance
  end

  def profit(date = Time.current)
    amount_invested_balance = amount_invested_balance(date)
    amount_updated_balance = amount_updated_balance(date)
    return 0 if amount_invested_balance.nil? || amount_updated_balance.nil?

    amount_updated_balance - amount_invested_balance
  end

  def balance(date = Time.current)
    balance = amount_updated_balance(date) || 0
    dollar = DollarPrice.step_business_day
    euro = EuroPrice.step_business_day
    uf = UfPrice.step_business_day
    mxn = MxnPrice.step_business_day
    cop = CopPrice.step_business_day
    crc = CrcPrice.step_business_day

    case currency
    when 'CLP'
      { CLP: balance.to_f, USD: (balance / dollar).to_f, EUR: (balance / euro).to_f, UF: (balance.to_f / uf).to_f, MXN: (balance.to_f / mxn).to_f, COP: (balance.to_f / cop).to_f, CRC: (balance.to_f / crc).to_f }
    when 'USD'
      { CLP: (balance.to_f * dollar).to_f, USD: balance.to_f, EUR: ( ((balance.to_f * dollar).to_f) / euro).to_f, UF: ((balance.to_f * dollar).to_f / uf).to_f, MXN: ((balance.to_f * dollar).to_f / mxn).to_f, COP: ((balance.to_f * dollar).to_f / cop).to_f, CRC: ((balance.to_f * dollar).to_f / crc).to_f  }
    when 'EUR'
      { CLP: (balance.to_f * euro).to_f, USD: ( ((balance.to_f * euro).to_f) / dollar ).to_f, EUR: balance.to_f, UF: ((balance.to_f * euro).to_f / uf).to_f, MXN: ((balance.to_f * euro).to_f / mxn).to_f, COP: ((balance.to_f * euro).to_f / cop).to_f, CRC: ((balance.to_f * euro).to_f / crc).to_f  }
    when 'UF'
      { CLP: (balance.to_f * uf).to_f, USD: ((balance.to_f * uf).to_f / dollar), EUR: ((balance.to_f * uf).to_f / euro).to_f, UF: balance.to_f, MXN: ((balance.to_f * uf).to_f / mxn).to_f, COP: ((balance.to_f * uf).to_f / cop).to_f, CRC: ((balance.to_f * uf).to_f / crc).to_f }
    when 'MXN'
      { CLP: (balance.to_f * mxn).to_f, USD: ((balance.to_f * mxn).to_f / dollar), EUR: ((balance.to_f * mxn).to_f / euro).to_f, UF: ((balance.to_f * mxn).to_f / uf).to_f , MXN: balance.to_f, COP: ((balance.to_f * mxn).to_f / cop).to_f, CRC: ((balance.to_f * mxn).to_f / crc).to_f }
    when 'COP'
      { CLP: (balance.to_f * cop).to_f, USD: ((balance.to_f * cop).to_f / dollar), EUR: ((balance.to_f * cop).to_f / euro).to_f, UF: ((balance.to_f * cop).to_f / uf).to_f , MXN: ((balance.to_f * cop).to_f / mxn).to_f, COP: balance.to_f, CRC: ((balance.to_f * cop).to_f / crc).to_f }
    when 'CRC'
      { CLP: (balance.to_f * crc).to_f, USD: ((balance.to_f * crc).to_f / dollar), EUR: ((balance.to_f * crc).to_f / euro).to_f, UF: ((balance.to_f * crc).to_f / uf).to_f , MXN: ((balance.to_f * crc).to_f / mxn).to_f, COP: ((balance.to_f * crc).to_f / cop).to_f, CRC: balance.to_f }
    else
      { CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0 }
    end
  end

  def asset_type
    investment_asset.asset_type
  end

  def currency
    investment_asset.currency
  end
end

# == Schema Information
#
# Table name: memberships
#
#  id                  :bigint(8)        not null, primary key
#  sub_account_id      :bigint(8)        not null
#  investment_asset_id :bigint(8)        not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  hidden              :boolean          default(FALSE)
#
# Indexes
#
#  index_memberships_on_investment_asset_id  (investment_asset_id)
#  index_memberships_on_sub_account_id       (sub_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (investment_asset_id => investment_assets.id)
#  fk_rails_...  (sub_account_id => sub_accounts.id)
#
