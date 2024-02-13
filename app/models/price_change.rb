class PriceChange < ApplicationRecord
  belongs_to :investment_asset
  belongs_to :money_movement, optional: true
  has_many :price_change_documents, dependent: :destroy

  validates :value, :price_changed_at, presence: true

  scope :from_file, -> { where(from_file: true) }
end

# == Schema Information
#
# Table name: price_changes
#
#  id                  :bigint(8)        not null, primary key
#  value               :float            not null
#  price_changed_at    :datetime         not null
#  investment_asset_id :bigint(8)        not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  money_movement_id   :bigint(8)
#  from_file           :boolean          default(FALSE)
#
# Indexes
#
#  index_price_changes_on_investment_asset_id  (investment_asset_id)
#  index_price_changes_on_money_movement_id    (money_movement_id)
#
# Foreign Keys
#
#  fk_rails_...  (investment_asset_id => investment_assets.id)
#
