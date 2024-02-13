class AddRutToAdvisers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :advisers, :rut, :string, limit: 12
    add_index :advisers, :rut, unique: true, algorithm: :concurrently
  end
end
