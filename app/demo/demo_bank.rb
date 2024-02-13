# rubocop:disable Layout/LineLength, Performance/Caller, Style/RedundantSelf
class DemoBank < ApplicationRecord
  self.table_name = "banks"

  has_many :accounts, class_name: "::DemoAccount"
  has_many :relation_files, class_name: "::DemoRelationFile", dependent: :nullify

  has_many :demo_accounts, class_name: "::DemoAccount"
  has_many :demo_relation_files, class_name: "::DemoRelationFile", dependent: :nullify

  def name
    REDIS.with do |conn|
      conn.get(field_name).nil? ? conn.set(field_name, Faker::Bank.name, ex: ENV["DEMO_EXPIRATION"].to_i) : conn.get(field_name)
      conn.get(field_name)
    end
  end

  private

  def field_name
    self.class.name + "_" + self.id.to_s + "_" + caller[0][/`.*'/][1..-2].to_s
  end
end
# rubocop:enable Layout/LineLength, Performance/Caller, Style/RedundantSelf

# == Schema Information
#
# Table name: banks
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
