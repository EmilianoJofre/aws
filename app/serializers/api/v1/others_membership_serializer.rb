class Api::V1::OthersMembershipSerializer < Api::V1::BaseSerializer
  attributes :id, :name, :description, :total_investment, :quantity, :last_values

  def last_values
    object.value_changes.last
  end
end
