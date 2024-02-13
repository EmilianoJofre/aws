class Api::V2::UserSerializer < Api::V2::BaseSerializer
  attributes :id, :name, :first_name, :last_name, :email, :rut, :type, :phone_number, :internal_id, :created_at

  def rut
    object.rut.gsub(/\./mi, '').gsub(/\s+/, '') if !object.rut.nil?
  end

  def internal_id
    return "VL-#{rut_number(object.rut)}" if !object.rut.nil?
    return "VL-ADMIN-#{object.id}"
  end
end
