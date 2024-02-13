class AddCountryToAccounts < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  
  def change
    add_reference :accounts, :country, null: true, index: {algorithm: :concurrently}
  end
end
