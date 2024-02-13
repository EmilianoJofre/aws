class Api::V2::RealEstateSerializer < Api::V2::BaseSerializer
  attributes :id, :name, :commune, :role, :lat, :lon, :location_sql, :address, :asset_destination, :contributions
  attributes :fiscal_appraisal, :area, :builded_area, :year, :force_update, :created_at, :updated_at
  attributes :last_values

  def last_values
    values = object.re_value_changes.last
    Api::V2::ReValueChangeSerializer.new(values) if !values.nil?
  end
end
