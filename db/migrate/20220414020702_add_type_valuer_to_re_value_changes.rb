class AddTypeValuerToReValueChanges < ActiveRecord::Migration[6.0]
  def change
    add_column :re_value_changes, :type_valuer, :integer
  end
end
