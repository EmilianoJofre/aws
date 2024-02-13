class AddFieldsToSupervisor < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :supervisors, :name }
    add_column :supervisors, :first_name, :string
    add_column :supervisors, :last_name, :string
    add_column :supervisors, :phone, :string
  end
end
