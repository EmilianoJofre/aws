class AlternativeName < ApplicationRecord
  belongs_to :membership
end

# == Schema Information
#
# Table name: alternative_names
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  membership_id :bigint(8)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_alternative_names_on_membership_id  (membership_id)
#
# Foreign Keys
#
#  fk_rails_...  (membership_id => memberships.id)
#
