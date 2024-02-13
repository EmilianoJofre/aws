class OthersMembership < ApplicationRecord
  belongs_to :membership
  belongs_to :investment_asset, optional: true
  
  def value_changes
    membership.external_value_changes
  end

  def vl_valorization
    return nil if self.value_changes.empty?
    values = self.value_changes.internal.last
    return nil if values.nil?
    values.total_value
  end

  def vl_valorization_date
    values = self.value_changes.internal.last
    return nil if values.nil?
    values.created_at.strftime('%Y-%m-%d %H:%M:%S %Z')
  end

  def external_valorization
    return nil if self.value_changes.empty?
    values = self.value_changes.external.last
    return nil if values.nil?
    values.total_value
  end

  def external_valorization_date
    return nil if self.value_changes.empty?
    values = self.value_changes.external.last
    return nil if values.nil?
    values.created_at.strftime('%Y-%m-%d %H:%M:%S %Z')
  end

  def external_valorization_name
    return nil if self.value_changes.empty?
    values = self.value_changes.external.last
    return nil if values.nil?
    values.valuer
  end
end

# == Schema Information
#
# Table name: liabilities
#
#  id                  :bigint(8)        not null, primary key
#  membership_id       :bigint(8)        not null
#  name                :string
#  description         :text
#  total_investment     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null