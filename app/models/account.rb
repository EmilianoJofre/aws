# rubocop:disable Rails/InverseOf
class Account < ApplicationRecord
  include LedgerizerAccountable
  include BalanceConcern
  include WalletConcern
  validates :name, :rut, :email, presence: true

  enum account_type: {
    investment: 0,
    pension_fund: 1,
    real_estate: 2,
    liability: 3,
    other: 4,
    insurance: 5,
    investment_insurance: 6
  }

  belongs_to :relation
  belongs_to :bank
  belongs_to :country
  has_many :relation_files, dependent: :nullify
  has_many :sub_accounts, dependent: :destroy
  has_many :memberships, through: :sub_accounts

  belongs_to :demo_relation,
             class_name: "::DemoRelation", foreign_key: :relation_id, optional: true

  scope :with_type, -> (type) { where('account_type = ?', type) }


  after_save :update_balance

  # Output example:
  # {
  #   "USD"=>{:variable_income=>0.117298498e7, :fixed_income=>0.16168834e6}, 
  #   "CLP"=>{:fixed_income=>0.12368e6}
  # }
  def balance_by_asset_type
    # Set asset_type_balance from first sub_account (Hash)
    account_balance = sub_accounts.first.balance_by_asset_type
    # Iterate if there are more sub_accounts
    sub_accounts.drop(1).each do |sub_account|
      sub_account_balance = sub_account.balance_by_asset_type
      # Iterate by currency, then add investment_asset_type amount to proper key-value pair
      sub_account_balance.keys.each do |currency|
        if account_balance[currency].nil?
          account_balance[currency] = sub_account_balance[currency]
        else
          sub_account_balance[currency].each do |k, v|
            account_balance[currency][k] ||= 0
            account_balance[currency][k] += v
          end
        end
      end
    end
    balance
  end

  def balance_by_currency
    balance = {}
    sub_accounts.each do |sub_account|
      currency = sub_account.currency
      balance[sub_account.currency.to_sym] ||= 0 
      balance[sub_account.currency.to_sym] += sub_account.updated_balance
    end
    balance
  end
  
  def investment_assets
    ids = Membership.where(sub_account_id: sub_accounts.pluck(:id)).pluck(:investment_asset_id)
    InvestmentAsset.where(id: ids)
  end

  def assets_memberships
    ids = investment_assets.where(asset_type: InvestmentAsset.assets)&.pluck(:id)
    Membership.where(investment_asset_id: ids, sub_account_id: sub_account_ids)
  end

  def liabilities_memberships
    ids = investment_assets.where(asset_type: InvestmentAsset.liabilities)&.pluck(:id)
    Membership.where(investment_asset_id: ids, sub_account_id: sub_account_ids)
  end

  def investments_memberships
    ids = investment_assets.where(asset_type: InvestmentAsset.investments)&.pluck(:id)
    Membership.where(investment_asset_id: ids, sub_account_id: sub_account_ids)
  end


  # Returns balance in CLP
  def balance_distribution(type)
    balance = 0
    memeberships = assets_memberships if type == 'assets'
    memeberships = liabilities_memberships if type == 'liabilities'
    memeberships = investments_memberships if type == 'investments'
    return if memeberships.nil?

    memeberships.each do |membership|
      balance += membership.updated_balance.to_f
    end
    balance
  end

  def investments_balance
    balance = {}
    investments_memberships.each do |membership|
      balance[membership.asset_type.to_sym] ||= 0
      balance[membership.asset_type.to_sym] += membership.updated_balance
    end
    balance
  end

  def update_balance
    new_balance = memberships.pluck(:updated_balance).reduce(:+)
    return if new_balance == updated_balance
    
    self.update_columns(updated_balance: new_balance, status: 'updated') 
    relation.update_balance
  end

  private

  def account_name_criteria_for_currency_total
    'account_total_wallet'
  end
end
# rubocop:enable Rails/InverseOf

# == Schema Information
#
# Table name: accounts
#
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  rut          :string           not null
#  email        :string           not null
#  relation_id  :bigint(8)        not null
#  bank_id      :bigint(8)        not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_type :integer
#
# Indexes
#
#  index_accounts_on_bank_id      (bank_id)
#  index_accounts_on_relation_id  (relation_id)
#
# Foreign Keys
#
#  fk_rails_...  (bank_id => banks.id)
#  fk_rails_...  (relation_id => relations.id)
#
