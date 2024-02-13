class Liability < ApplicationRecord
  belongs_to :membership
  belongs_to :investment_asset, optional: true
  
  enum payment_cycle: {
    monthly: 0,
    quarterly: 1,
    biannual: 2,
    annual: 3,
    to_the_end: 4
  }

  enum rate_type: {
    fixed: 0,
    variable: 1,
    mixed: 2
  }

  def next_payment_date
    self.start_date + (self.fees_paid.to_i * payment_cycle_in_months.to_i).months
  end

  def days_to_next_payment_date
    (next_payment_date - Date.current).to_i
  end

  private

  def payment_cycle_in_months
    case self.payment_cycle
    when "monthly"
      return 1
    when "quarterly"
      return 3
    when "biannual"
      return 6
    when "annual"
      return 12
    end
  end
end

# == Schema Information
#
# Table name: liabilities
#
#  id                  :bigint(8)        not null, primary key
#  membership_id       :bigint(8)        not null
#  investment_asset_id :bigint(8)
#  name                :string
#  description         :text
#  initial_debt        :float
#  debt_participation  :float
#  total_fees          :integer
#  fees_paid           :integer
#  outstanding_balance :integer
#  start_date          :date
#  end_date            :date
#  payment_cycle       :integer
#  rate                :float
#  rate_description    :string
#  rate_type           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_liabilities_on_investment_asset_id  (investment_asset_id)
#  index_liabilities_on_membership_id        (membership_id)
#
# Foreign Keys
#
#  fk_rails_...  (investment_asset_id => investment_assets.id)
#  fk_rails_...  (membership_id => memberships.id)
#
