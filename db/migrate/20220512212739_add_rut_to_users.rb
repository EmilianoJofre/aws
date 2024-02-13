class AddRutToUsers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :users, :rut, :string, limit: 12
    add_index :users, :rut, unique: true, algorithm: :concurrently
  end
end
