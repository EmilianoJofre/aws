class AddFieldsToReValueChanges < ActiveRecord::Migration[6.0]
  def change
    add_column :re_value_changes, :date, :date
    add_column :re_value_changes, :valuer, :string
  end
end
