# rubocop:disable Layout/LineLength, Style/RedundantSelf, Rails/RedundantForeignKey
class DemoMoneyMovement < ApplicationRecord
  include LedgerizerDocument

  self.table_name = 'money_movements'

  belongs_to :sub_account, class_name: "::DemoSubAccount", foreign_key: :sub_account_id
  belongs_to :membership, class_name: "::DemoMembership"
  has_one :price_change, dependent: :destroy
  belongs_to :deleted_by, class_name: "MoneyMovement", optional: true

  delegate :account, to: :sub_account
  delegate :relation, to: :account
  delegate :user, to: :relation
  delegate :asset_id, to: :membership, prefix: false

  belongs_to :demo_sub_account, class_name: "::DemoSubAccount", foreign_key: :sub_account_id
  belongs_to :demo_membership, class_name: "::DemoMembership"
  has_one :price_change, dependent: :destroy
  belongs_to :deleted_by, class_name: "MoneyMovement", optional: true

  delegate :demo_account, to: :demo_sub_account
  delegate :demo_relation, to: :demo_account
  delegate :user, to: :demo_relation
  delegate :asset_id, to: :demo_membership, prefix: false

  validates :average_price, :quotas, :date, presence: true

  enum movement_type: { purchase: 0, sale: 1 }

  validate :quotas_amount

  scope :valid, -> { where(deleted_by: nil) }

  def amount
    REDIS.with do |conn|
      conn.get(field_name_of_quota).nil? ? conn.set(field_name_of_quota, quotas * rand(1.4..1.8), ex: ENV["DEMO_EXPIRATION"].to_i) : conn.get(field_name_of_quota)
      return (conn.get(field_name_of_quota).to_i * average_price)
    end
  end

  private

  def quotas_amount
    if (movement_type == 'sale') && sale_is_invalid
      errors.add(:quotas, "QuotasAmountError")
    end

    errors.add(:quotas, 'QuotasAmountError') if quotas&.zero?
  end

  def positive_average_price
    if average_price&.zero? || average_price&.negative?
      errors.add(:average_price, 'AveragePriceError')
    end
  end

  def sale_is_invalid
    (
      membership.quotas_balance.nil? || quotas > membership.quotas_balance(date)
    ) && deleted_by_id.nil?
  end

  def field_name_of_quota
    "membership_quota_" + self.membership.id.to_s
  end
end
# rubocop:enable Layout/LineLength, Style/RedundantSelf, Rails/RedundantForeignKey

# == Schema Information
#
# Table name: money_movements
#
#  id             :bigint(8)        not null, primary key
#  quotas         :integer          not null
#  date           :datetime         not null
#  sub_account_id :bigint(8)        not null
#  membership_id  :bigint(8)        not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  movement_type  :integer
#  average_price  :float
#  deleted_by_id  :integer
#
# Indexes
#
#  index_money_movements_on_membership_id   (membership_id)
#  index_money_movements_on_sub_account_id  (sub_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (membership_id => memberships.id)
#  fk_rails_...  (sub_account_id => sub_accounts.id)
#
