class Aum < ApplicationRecord
end

# == Schema Information
#
# Table name: aums
#
#  id         :bigint(8)        not null, primary key
#  aum        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_aums_on_created_at  (created_at)
#
