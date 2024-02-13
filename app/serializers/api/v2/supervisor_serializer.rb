class Api::V2::SupervisorSerializer < Api::V2::BaseSerializer
  attributes :id, :name, :first_name, :last_name, :rut, :email, :phone, :type, :vendor_id, :internal_id, :created_at
  attribute :advisers_quantity, if: :resume?
  attribute :investors_quantity, if: :resume?

  def rut
    object.rut.gsub(/\./mi, '').gsub(/\s+/, '') if !object.rut.nil?
  end

  def internal_id
    return "VL-#{rut_number(object.rut)}" if !object.rut.nil?
    return "VL-SUPERVISOR-#{object.id}"
  end

  def advisers_quantity
    object.advisers.count
  end

  def investors_quantity
    count = 0
    object.advisers.map do |adviser|
      count += adviser.relations.count
    end
    count
  end
end
