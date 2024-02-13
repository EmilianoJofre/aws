class Commune < ApplicationRecord
end

# == Schema Information
#
# Table name: communes
#
#  id             :bigint(8)        not null, primary key
#  name           :string
#  code_sii       :integer
#  code_tesoreria :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
