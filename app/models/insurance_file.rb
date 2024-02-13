class InsuranceFile < ApplicationRecord
  belongs_to :insurance

  include InsuranceDocumentUploader::Attachment(:file)

end

# == Schema Information
#
# Table name: insurance_files
#
#  id             :bigint(8)        not null, primary key
#  insurance_id   :bigint(8)        not null, primary key
#  file_data      :jsonb
