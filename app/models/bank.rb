class Bank < ApplicationRecord
  validates :name, presence: true

  has_many :accounts, dependent: :destroy
  has_many :relation_files, dependent: :nullify
end

# == Schema Information
#
# Table name: banks
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
