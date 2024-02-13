# rubocop:disable Layout/LineLength, Style/RedundantSelf, Performance/Caller
class DemoRelation < ApplicationRecord
  include LedgerizerAccountable
  include WalletConcern

  self.table_name = "relations"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  extend Enumerize
  belongs_to :user
  has_many :relation_accounts,
           class_name: "::DemoAccount",
           dependent: :destroy, inverse_of: :relation, foreign_key: :relation_id
  has_many :sub_accounts, class_name: "::DemoSubAccount", through: :relation_accounts
  has_many :memberships, class_name: "::DemoMembership", through: :sub_accounts
  has_many :money_movements, class_name: "::DemoMoneyMovement", through: :memberships
  has_many :investment_assets, class_name: "::DemoInvestmentAsset", through: :memberships
  has_many :relation_histories, class_name: "::DemoRelationHistory", foreign_key: :relation_id, dependent: :destroy
  has_many :relation_files,
           class_name: "::DemoRelationFile", dependent: :destroy, foreign_key: :relation_id

  has_many :demo_relation_accounts,
           class_name: "::DemoAccount", inverse_of: :demo_relation, foreign_key: :relation_id
  has_many :demo_sub_accounts, class_name: "::DemoSubAccount", through: :demo_relation_accounts
  has_many :demo_memberships, class_name: "::DemoMembership", through: :demo_sub_accounts
  has_many :demo_money_movements, class_name: "::DemoMoneyMovement", through: :demo_memberships
  has_many :demo_investment_assets, class_name: "::DemoInvestmentAsset", through: :demo_memberships
  has_many :demo_relation_histories, class_name: "::DemoRelationHistory", foreign_key: :relation_id, dependent: :destroy
  has_many :demo_relation_files,
           class_name: "::DemoRelationFile", dependent: :destroy, foreign_key: :relation_id

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def initialAndLastname
    "#{first_name[0]}. #{last_name}"
  end
  
  def first_name
    REDIS.with do |conn|
      if conn.get(field_name).nil?
        conn.set(field_name, Faker::Name.first_name, ex: ENV["DEMO_EXPIRATION"].to_i)
      else
        conn.get(field_name)
      end
      conn.get(field_name)
    end
  end

  def last_name
    REDIS.with do |conn|
      if conn.get(field_name).nil?
        conn.set(field_name, Faker::Name.last_name, ex: ENV["DEMO_EXPIRATION"].to_i)
      else
        conn.get(field_name)
      end
      conn.get(field_name)
    end
  end

  def rut
    REDIS.with do |conn|
      if conn.get(field_name).nil?
        conn.set(field_name, Faker::ChileRut.full_rut, ex: ENV["DEMO_EXPIRATION"].to_i)
      else
        conn.get(field_name)
      end
      conn.get(field_name)
    end
  end

  def email
    REDIS.with do |conn|
      if conn.get(field_name).nil?
        conn.set(field_name, Faker::Internet.email(name: self.first_name), ex: ENV["DEMO_EXPIRATION"].to_i)
      else
        conn.get(field_name)
      end
      conn.get(field_name)
    end
  end

  def phone
    REDIS.with do |conn|
      if conn.get(field_name).nil?
        conn.set(field_name, Faker::PhoneNumber.cell_phone_in_e164, ex: ENV["DEMO_EXPIRATION"].to_i)
      else
        conn.get(field_name)
      end
      conn.get(field_name)
    end
  end

  private

  def field_name
    self.class.name + "_" + self.id.to_s + "_" + caller[0][/`.*'/][1..-2].to_s
  end

  def account_name_criteria_for_currency_total
    'relation_total_wallet'
  end
end
# rubocop:enable Layout/LineLength, Style/RedundantSelf, Performance/Caller

# == Schema Information
#
# Table name: relations
#
#  id                     :bigint(8)        not null, primary key
#  first_name             :string           not null
#  last_name              :string           not null
#  rut                    :string           not null
#  email                  :string           not null
#  phone                  :string
#  user_id                :bigint(8)        not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  show_wallet            :boolean          default(FALSE)
#
# Indexes
#
#  index_relations_on_email                 (email) UNIQUE
#  index_relations_on_reset_password_token  (reset_password_token) UNIQUE
#  index_relations_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
