class AddAuthenticationTokenToRelations < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    add_column :relations, :authentication_token, :string, limit: 30
    add_index :relations, :authentication_token, unique: true, algorithm: :concurrently
  end
end
