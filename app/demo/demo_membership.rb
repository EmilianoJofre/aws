# rubocop:disable Layout/LineLength, Lint/UnusedMethodArgument, Style/RedundantSelf, Rails/RedundantForeignKey
class DemoMembership < ApplicationRecord
  include LedgerizerAccountable

  self.table_name = 'memberships'

  belongs_to :sub_account, class_name: "::DemoSubAccount", foreign_key: :sub_account_id
  belongs_to :investment_asset, class_name: "::DemoInvestmentAsset", foreign_key: :investment_asset_id
  has_many :money_movements,
           class_name: "DemoMoneyMovement", foreign_key: :membership_id, dependent: :destroy
  has_many :price_change_documents, dependent: :destroy
  delegate :account, :currency, to: :sub_account
  delegate :relation, to: :account
  delegate :user, to: :relation
  delegate :is_custom, to: :investment_asset
  delegate :asset_id, to: :investment_asset, prefix: false

  belongs_to :demo_sub_account, class_name: "::DemoSubAccount", foreign_key: :sub_account_id
  belongs_to :demo_investment_asset,
             class_name: "::DemoInvestmentAsset", foreign_key: :investment_asset_id
  has_many :demo_money_movements,
           class_name: "DemoMoneyMovement", foreign_key: :membership_id, dependent: :destroy
  delegate :demo_account, :currency, to: :demo_sub_account
  delegate :demo_relation, to: :demo_account
  delegate :is_custom, to: :demo_investment_asset
  delegate :asset_id, to: :demo_investment_asset, prefix: false

  scope :with_custom_asset, -> {
    joins(:investment_asset).where(investment_assets: { is_custom: true })
  }
  scope :without_custom_asset, -> {
    joins(:investment_asset).where(investment_assets: { is_custom: false })
  }

  scope :active, -> { where(hidden: false) }

  def quotas_balance(date = Time.current)
    new_quotas = (membership.money_movements.all.sum(:quotas) * rand(1.4..1.8)).to_i
    REDIS.with do |conn|
      conn.get(field_name("quotas")).nil? ? conn.set(field_name("quotas"), new_quotas, ex: ENV["DEMO_EXPIRATION"].to_i) : conn.get(field_name("quotas"))
      conn.get(field_name("quotas")).to_i
    end
  end

  def amount_invested_balance(date = Time.current)
    # membership.accounts.find_by(name: 'amount_invested')&.balance_at(date)&.amount
    quotas_balance(date) * membership.money_movements.all.average(:average_price).to_f
  end

  def amount_updated_balance(date = Time.current)
    # membership.accounts.find_by(name: 'amount_updated')&.balance_at(date)&.amount
    quotas_balance(date) * membership.money_movements.all.average(:average_price).to_f
  end

  def incomes_balance(date = Time.current)
    membership.accounts.find_by(name: 'investment_incomes')&.balance_at(date)&.amount
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
    case currency
    when 'CLP'
      { CLP: balance.to_f, USD: (balance / dollar).to_f, EUR: (balance / euro).to_f, UF: (balance / euro).to_f }
    when 'USD'
      { CLP: (balance.to_f * dollar).to_f, USD: balance.to_f, EUR: ( ((balance.to_f / dollar).to_f) * euro).to_f, UF: balance.to_f }
    when 'EUR'
      { CLP: (balance.to_f * euro).to_f, USD: ( ((balance.to_f * euro).to_f) * dollar ).to_f, EUR: balance.to_f, UF: balance.to_f }
    when 'UF'
      { CLP: (balance.to_f * euro).to_f, USD: ( ((balance.to_f * euro).to_f) * dollar ).to_f, EUR: balance.to_f, UF: balance.to_f }
    else
      { CLP: 0, USD: 0, EUR: 0, UF: 0 }
    end
  end

  private

  def membership
    Membership.find(self.id)
  end

  def field_name(name)
    "membership_" + name + "_" + self.id.to_s
  end
end
# rubocop:enable Layout/LineLength, Lint/UnusedMethodArgument, Style/RedundantSelf, Rails/RedundantForeignKey

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
