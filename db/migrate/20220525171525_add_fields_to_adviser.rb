class AddFieldsToAdviser < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :advisers, :name }
    add_column :advisers, :first_name, :string
    add_column :advisers, :last_name, :string
    add_column :advisers, :phone, :string
  end
end
