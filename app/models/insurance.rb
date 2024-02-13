class Insurance < ApplicationRecord
  belongs_to :membership
  has_one :insurance_file
  
  self.ignored_columns = ["insurance_document_id"]


end

# == Schema Information
#
# Table name: insurances
#
#  id                       :bigint(8)        not null, primary key
#  membership_id            :bigint(8)        not null
#  name                     :string
#  details                  :text
#  insuree                  :string
#  beneficiary              :string
#  prime                    :float
#  insured_capital          :float
#  insurance_file_id        :bigint(8)
#  policy_end               :datetime
#  policy_renovation        :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#