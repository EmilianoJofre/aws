class Api::V2::AdviserSerializer < Api::V2::BaseSerializer
  attributes :id, :name, :first_name, :last_name, :rut, :email, :phone, :type, :internal_id, :created_at
  attribute :investors_quantity, if: :resume?
  attribute :accounts_quantity, if: :resume?
  attribute :total_balance, if: :resume?

  def rut
    object.rut.gsub(/\./mi, '').gsub(/\s+/, '') if !object.rut.nil?
  end

  def internal_id
    return "VL-#{rut_number(object.rut)}" if !object.rut.nil?
    return "VL-ADVISER-#{object.id}"
  end

  def investors_quantity
    object.relations.count
  end

  def accounts_quantity
    ids = object.relation_ids
    Account.where(relation_id: ids).count
  end

  def total_balance
    total = 0
    object.relations.map do |relation|
      total += relation.updated_balance
    end
    return total
  end
end
