class Vendor < ApplicationRecord
  has_many :supervisors, dependent: :destroy

  def json_vars
    JSON.parse(vars)
  end
end

# == Schema Information
#
# Table name: vendors
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
