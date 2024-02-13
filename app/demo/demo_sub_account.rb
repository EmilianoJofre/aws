# rubocop:disable Rails/RedundantForeignKey
class DemoSubAccount < ApplicationRecord
  include BalanceConcern
  include CurrencyConcern
  include LedgerizerAccountable

  self.table_name = 'sub_accounts'

  belongs_to :account,
             class_name: "::DemoAccount", foreign_key: :account_id
  has_many :memberships, class_name: "::DemoMembership", foreign_key: :sub_account_id
  has_many :investment_assets, class_name: "::DemoInvestmentAsset", through: :memberships
  has_many :money_movements,
           class_name: "::DemoMoneyMovement", foreign_key: :sub_account_id, dependent: :destroy
  has_many :wallet_deposits, dependent: :destroy
  has_many :wallet_withdrawals, dependent: :destroy
  has_many :relation_files, dependent: :nullify

  belongs_to :demo_account, class_name: "::DemoAccount", foreign_key: :account_id
  has_many :demo_memberships, class_name: "::DemoMembership", foreign_key: :sub_account_id
  has_many :demo_investment_assets, class_name: "::DemoInvestmentAsset", through: :demo_memberships
  has_many :demo_money_movements,
           class_name: "::DemoMoneyMovement", foreign_key: :sub_account_id, dependent: :destroy

  def currency_total_wallet(date = Time.current)
    accounts.find_by(name: 'wallet', currency: currency)&.balance_at(date)&.amount
  end

  def wallet(date = Time.current)
    currency_total_wallet(date).to_f
  end
end
# rubocop:enable Rails/RedundantForeignKey

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
