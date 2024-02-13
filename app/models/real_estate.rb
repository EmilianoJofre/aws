class RealEstate < ApplicationRecord
  belongs_to :membership
  has_many :re_value_changes, dependent: :destroy
  validates :name, :commune, :role, :total_inversion, presence: true
  validates :role, uniqueness: true

  def vl_valorization
    return nil if self.re_value_changes.empty?
    values = self.re_value_changes.internal.last
    return nil if values.nil?
    values.total_value
  end

  def vl_valorization_date
    values = self.re_value_changes.internal.last
    return nil if values.nil?
    values.created_at.strftime('%Y-%m-%d %H:%M:%S %Z')
  end

  def external_valorization
    return nil if self.re_value_changes.empty?
    values = self.re_value_changes.external.last
    return nil if values.nil?
    values.total_value
  end

  def external_valorization_date
    return nil if self.re_value_changes.empty?
    values = self.re_value_changes.external.last
    return nil if values.nil?
    values.date.strftime('%Y-%m-%d %H:%M:%S %Z')
  end

  def external_valorization_name
    return nil if self.re_value_changes.empty?
    values = self.re_value_changes.external.last
    return nil if values.nil?
    values.valuer
  end
end

# == Schema Information
#
# Table name: real_estates
#
#  id                :bigint(8)        not null, primary key
#  membership_id     :bigint(8)        not null
#  commune           :string
#  role              :string
#  lat               :string
#  lon               :string
#  location_sql      :string
#  address           :string
#  asset_destination :string
#  contributions     :float
#  fiscal_appraisal  :float
#  area              :float
#  builded_area      :float
#  year              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  force_update      :boolean          default(FALSE)
#  name              :string
#  total_inversion   :integer
#
# Indexes
#
#  index_real_estates_on_membership_id  (membership_id)
#
# Foreign Keys
#
#  fk_rails_...  (membership_id => memberships.id)
#
