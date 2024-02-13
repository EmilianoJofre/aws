class SubAccount < ApplicationRecord
  include BalanceConcern
  include CurrencyConcern
  include LedgerizerAccountable

  belongs_to :account
  has_many :memberships, dependent: :destroy
  has_many :investment_assets, through: :memberships
  has_many :money_movements, dependent: :destroy
  has_many :wallet_deposits, dependent: :destroy
  has_many :wallet_withdrawals, dependent: :destroy
  has_many :relation_files, dependent: :nullify

  validates :currency, :sub_account_id, presence: true

  def name
    "#{sub_account_id} en #{currency}"
  end

  def currency_total_wallet(date = Time.current)
    accounts.find_by(name: 'wallet', currency: currency)&.balance_at(date)&.amount
  end

  def wallet(date = Time.current)
    currency_total_wallet(date).to_f
  end

  def consolidated_balance
    balance = 0
    if !membership.amount_updated_balance.nil? then
      balance = balance + membership.amount_updated_balance
    end
    balance
  end

  def balance_by_country
    memberships.joins('inner join investment_assets on investment_assets.id = memberships.investment_asset_id')
               .where('investment_assets.asset_type != ?', InvestmentAsset.asset_types["liability"])
  end

  def update_balance
    new_balance = memberships.pluck(:updated_balance).reduce(:+)
    return if new_balance == updated_balance
    
    self.update_columns(updated_balance: new_balance, status: 'updated') 
  end

end

# == Schema Information
#
# Table name: sub_accounts
#
#  id             :bigint(8)        not null, primary key
#  currency       :integer          not null
#  sub_account_id :string           not null
#  account_id     :bigint(8)        not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_sub_accounts_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
