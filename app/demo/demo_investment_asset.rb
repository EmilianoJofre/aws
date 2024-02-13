class DemoInvestmentAsset < ApplicationRecord
  include CurrencyConcern
  include LedgerizerAccountable
  extend Enumerize

  self.table_name = 'investment_assets'

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
    money_market: 10
  }

  has_many :memberships, class_name: "::DemoMembership", foreign_key: :investment_asset_id
  has_many :sub_accounts, through: :memberships
  has_many :price_changes, dependent: :destroy

  has_many :demo_memberships, class_name: "::DemoMembership", foreign_key: :investment_asset_id
  has_many :demo_sub_accounts, through: :demo_memberships
  has_many :price_changes, dependent: :destroy

  scope :valid, -> { where(valid_asset: true) }
  scope :not_custom, -> { where(is_custom: false) }
  scope :investment_instruments, -> { where('asset_type <= 5') }
  scope :pension_funds, -> { where(asset_type: 6) }
  scope :real_estates, -> { where(asset_type: 7) }
  scope :others, -> { where(asset_type: 8) }
  scope :all_type, -> { where('asset_type >= 0') }
  
  def last_price_change
    price_changes.where(money_movement_id: nil).order(price_changed_at: :asc).last
  end
end

# == Schema Information
#
# Table name: investment_assets
#
#  id             :bigint(8)        not null, primary key
#  name           :string           not null
#  asset_id       :string           not null
#  currency       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  valid_asset    :boolean          default(FALSE)
#  asset_type     :integer
#  is_custom      :boolean          default(FALSE)
#  mtd            :float
#  recovery_level :float
#  qtd            :float
#  ytd            :float
#  y1             :float
#  y3             :float
#  y5             :float
#  sub_sector     :string
#
# Indexes
#
#  index_investment_assets_on_asset_id  (asset_id) UNIQUE
#
