class MoneyMovement < ApplicationRecord
  include LedgerizerDocument

  paginates_per 10

  belongs_to :sub_account
  belongs_to :membership
  has_one :price_change, dependent: :destroy
  belongs_to :deleted_by, class_name: "MoneyMovement", optional: true

  delegate :account, to: :sub_account
  delegate :relation, to: :account
  delegate :user, to: :relation
  delegate :asset_id, to: :membership, prefix: false

  validates :average_price, :quotas, :date, presence: true

  enum movement_type: { purchase: 0, sale: 1 }

  validate :quotas_amount

  scope :valid, -> { where(deleted_by: nil) }
  scope :purchase, -> { where(movement_type: 0) }
  scope :sale, -> { where(movement_type: 1) }

  # Callbacks
  after_save :update_membership

  def amount
    quotas * average_price
  end

  def update_membership
    membership.update(updated_balance: membership.balance[:CLP], status: 'updated')
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
    return false if !membership.liabilities.empty?
    (
      membership.quotas_balance.nil? || quotas > membership.quotas_balance(date)
    ) && deleted_by_id.nil?
  end
end

# == Schema Information
#
# Table name: money_movements
#
#  id             :bigint(8)        not null, primary key
#  quotas         :float            not null
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
