# rubocop:disable Layout/LineLength, Style/RedundantSelf, Performance/Caller
class DemoAccount < ApplicationRecord
  include LedgerizerAccountable
  include BalanceConcern
  include WalletConcern

  self.table_name = "accounts"

  belongs_to :relation, class_name: "::DemoRelation"
  belongs_to :bank, class_name: "::DemoBank"
  has_many :relation_files, dependent: :nullify
  has_many :sub_accounts, class_name: "::DemoSubAccount", foreign_key: :account_id
  has_many :memberships, class_name: "::DemoMembership", through: :sub_accounts

  belongs_to :demo_relation, class_name: "::DemoRelation", foreign_key: :relation_id
  belongs_to :bank, class_name: "::DemoBank"
  has_many :demo_sub_accounts, class_name: "::DemoSubAccount", foreign_key: :account_id
  has_many :demo_memberships, through: :demo_sub_accounts, foreign_key: :sub_account_id

  def name
    REDIS.with do |conn|
      conn.get(field_name).nil? ? conn.set(field_name, Faker::Company.name + " " + Faker::Company.suffix, ex: ENV["DEMO_EXPIRATION"].to_i) : conn.get(field_name)
      return conn.get(field_name)
    end
  end

  def rut
    REDIS.with do |conn|
      conn.get(field_name).nil? ? conn.set(field_name, Faker::ChileRut.full_rut, ex: ENV["DEMO_EXPIRATION"].to_i) : conn.get(field_name)
      return conn.get(field_name)
    end
  end

  def email
    REDIS.with do |conn|
      conn.get(field_name).nil? ? conn.set(field_name, Faker::Internet.email(name: self.name), ex: ENV["DEMO_EXPIRATION"].to_i) : conn.get(field_name)
      return conn.get(field_name)
    end
  end

  private

  def field_name
    self.class.name + "_" + self.id.to_s + "_" + caller[0][/`.*'/][1..-2].to_s
  end

  def account_name_criteria_for_currency_total
    'account_total_wallet'
  end
end
# rubocop:enable Layout/LineLength, Style/RedundantSelf, Performance/Caller

# == Schema Information
#
# Table name: accounts
#
#  id          :bigint(8)        not null, primary key
#  name        :string           not null
#  rut         :string           not null
#  email       :string           not null
#  relation_id :bigint(8)        not null
#  bank_id     :bigint(8)        not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_accounts_on_bank_id      (bank_id)
#  index_accounts_on_relation_id  (relation_id)
#
# Foreign Keys
#
#  fk_rails_...  (bank_id => banks.id)
#  fk_rails_...  (relation_id => relations.id)
#
