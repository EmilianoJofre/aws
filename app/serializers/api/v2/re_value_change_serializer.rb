class Api::V2::ReValueChangeSerializer < Api::V2::BaseSerializer
  attributes :id, :builded_value, :area_value, :total_value
  attribute :date, key: :updated
  attribute :valuer
end
