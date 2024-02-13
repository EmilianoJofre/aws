class AddAuthenticationTokenToAdvisers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :advisers, :authentication_token, :string, limit: 30
    add_index :advisers, :authentication_token, unique: true, algorithm: :concurrently
  end
end
