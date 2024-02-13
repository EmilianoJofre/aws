class ExternalValueChange < ApplicationRecord
  belongs_to :membership
  enum type_valuer: {
    internal: 0,
    external: 1
  }
  scope :internal, -> { where(:type_valuer => 0)}
  scope :external, -> { where(:type_valuer => 1)}
end

# == Schema Information
#
# Table name: external_value_changes
#
#  id             :bigint(8)        not null, primary key
#  membership_id :bigint(8)        not null
#  total_value    :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  date           :date
#  valuer         :string
#  type_valuer    :integer
#
# Indexes
#
#  index_external_value_changes_on_membership_id  (membership_id)
#
# Foreign Keys
#
#  fk_rails_...  (real_estate_id => real_estates.id)
#
