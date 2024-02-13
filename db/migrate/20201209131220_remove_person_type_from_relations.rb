class RemovePersonTypeFromRelations < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :relations, :person_type }
  end
end
