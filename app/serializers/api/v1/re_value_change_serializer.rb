class Api::V1::ReValueChangeSerializer < Api::V1::BaseSerializer
  attributes :id, :builded_value, :area_value, :total_value
  attribute :date, key: :updated
  attribute :valuer
end
