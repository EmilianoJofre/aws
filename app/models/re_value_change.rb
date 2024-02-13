class ReValueChange < ApplicationRecord
  belongs_to :real_estate
  enum type_valuer: {
    internal: 0,
    external: 1
  }
  scope :internal, -> { where(:type_valuer => 0)}
  scope :external, -> { where(:type_valuer => 1)}
end

# == Schema Information
#
# Table name: re_value_changes
#
#  id             :bigint(8)        not null, primary key
#  real_estate_id :bigint(8)        not null
#  builded_value  :float
#  area_value     :float
#  total_value    :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  date           :date
#  valuer         :string
#  type_valuer    :integer
#
# Indexes
#
#  index_re_value_changes_on_real_estate_id  (real_estate_id)
#
# Foreign Keys
#
#  fk_rails_...  (real_estate_id => real_estates.id)
#
