class InvestmentAsset < ApplicationRecord
  include CurrencyConcern
  include LedgerizerAccountable
  extend Enumerize

  enum asset_type: {
    fixed_income: 0,
    variable_income: 1,
    alternative_asset: 2,
    balanced_asset: 3,
    structured_asset: 4,
    forward_asset: 5,
    pension_fund: 6,
    real_estate: 7,
    others: 8,
    liability: 9,
    money_market: 10,
    insurance: 11,
    investment_insurance: 12
  }

  has_many :memberships, dependent: :destroy
  has_many :sub_accounts, through: :memberships
  has_many :price_changes, dependent: :destroy

  validates :name, :asset_id, :currency, :asset_type, presence: true
  validates :asset_id, uniqueness: { case_sensitive: false }

  scope :valid, -> { where(valid_asset: true) }
  scope :not_custom, -> { where(is_custom: false) }
  scope :investment_instruments, -> { where('asset_type <= 5') }
  scope :pension_funds, -> { where(asset_type: 6) }
  scope :real_estates, -> { where(asset_type: 7) }
  scope :others, -> { where(asset_type: 8) }
  scope :liabilities, -> { where(asset_type: 9) }
  scope :all_type, -> { where('asset_type >= 0') }

  def last_price_change
    price_changes.where(money_movement_id: nil).order(price_changed_at: :asc).last
  end

  def self.assets
    assets = self.asset_types.to_h
    assets.delete("liability")
    assets.values
  end

  def self.liabilities
    self.asset_types[:liability]
  end

  def self.investments
    types = self.asset_types
    [types[:fixed_income], types[:variable_income], types[:alternative_asset], types[:balanced_asset], types[:structured_asset], types[:forward_asset], types[:money_market]] 
  end

  def countries_percentage
    percentages = {}
    return nil if countries_distribution.blank?
    
    countries_distribution.each do |country|
      name = country.first.split("Country_").last[0...-4].split('_').join(' ')
      percentages[name] = country.second
    end
    percentages
  end
end

# == Schema Information
#
# Table name: investment_assets
#
#  id                  :bigint(8)        not null, primary key
#  name                :string           not null
#  asset_id            :string           not null
#  currency            :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  valid_asset         :boolean          default(FALSE)
#  asset_type          :integer
#  is_custom           :boolean          default(FALSE)
#  mtd                 :float
#  recovery_level      :float
#  qtd                 :float
#  ytd                 :float
#  y1                  :float
#  y3                  :float
#  y5                  :float
#  sub_sector          :string
#  average_annual_cost :float
#
# Indexes
#
#  index_investment_assets_on_asset_id  (asset_id) UNIQUE
#
