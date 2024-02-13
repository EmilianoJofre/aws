# rubocop:disable Rails/RedundantForeignKey, Rails/InverseOf, Rails/HasManyOrHasOneDependent
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include LedgerizerTenant
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  has_many :relations, dependent: :destroy
  has_many :relation_accounts, through: :relations
  has_many :relation_files, through: :relations
  has_many :sub_accounts, through: :relation_accounts

  has_many :demo_relation,
           class_name: "::DemoRelation", foreign_key: :user_id
  has_many :demo_relation_accounts, through: :demo_relation
  has_many :relation_files, through: :demo_relation
  has_many :sub_accounts, through: :demo_relation_accounts

  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, length: { minimum: 2 }

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def initialAndLastname
    "#{first_name[0]}. #{last_name}"
  end

  def name
    "#{first_name} #{last_name}"
  end

  def internal_id
    "VL-#{id}#{initials}"
  end

  def type
    'admin'
  end
end
# rubocop:enable Rails/RedundantForeignKey, Rails/InverseOf, Rails/HasManyOrHasOneDependent

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  phone_number           :string
#  first_name             :string           not null
#  last_name              :string           not null
#  institution            :string
#  authentication_token   :string(30)
#  rut                    :string(12)
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_rut                   (rut) UNIQUE
#
