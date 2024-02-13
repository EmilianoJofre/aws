class Adviser < ApplicationRecord
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  
  has_many :supervisor_advisers
  has_many :supervisors, through: :supervisor_advisers
  accepts_nested_attributes_for :supervisors

  has_many :adviser_relations
  has_many :relations, through: :adviser_relations

  def name 
    "#{first_name} #{last_name}"
  end

  def type
    'adviser'
  end
end

# == Schema Information
#
# Table name: advisers
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string(30)
#  rut                    :string(12)
#  first_name             :string
#  last_name              :string
#  phone                  :string
#  active                 :boolean          default(TRUE), not null
#
# Indexes
#
#  index_advisers_on_authentication_token  (authentication_token) UNIQUE
#  index_advisers_on_email                 (email) UNIQUE
#  index_advisers_on_reset_password_token  (reset_password_token) UNIQUE
#  index_advisers_on_rut                   (rut) UNIQUE
#
