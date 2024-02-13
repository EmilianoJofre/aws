class AddRutToSupervisors < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :supervisors, :rut, :string, limit: 12
    add_index :supervisors, :rut, unique: true, algorithm: :concurrently
  end
end
