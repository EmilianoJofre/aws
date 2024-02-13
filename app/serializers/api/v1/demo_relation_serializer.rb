class Api::V1::DemoRelationSerializer < Api::V1::BaseSerializer
  attributes :id, :first_name, :last_name, :rut, :email, :phone, :show_wallet
end
