class SupervisorAdviser < ApplicationRecord
  belongs_to :supervisor
  belongs_to :adviser
end

# == Schema Information
#
# Table name: supervisor_advisers
#
#  id            :bigint(8)        not null, primary key
#  supervisor_id :bigint(8)
#  adviser_id    :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_supervisor_advisers_on_adviser_id     (adviser_id)
#  index_supervisor_advisers_on_supervisor_id  (supervisor_id)
#
