class Api::V1::RelationSerializer < Api::V1::BaseSerializer
  attributes :id, :name, :first_name, :last_name, :rut, :email, :phone, :show_wallet, :type, :internal_id, :created_at
end
