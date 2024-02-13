class CreateSubAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_accounts do |t|
      t.integer :currency, null: false
      t.string :sub_account_id, null: false
      t.references :account, null: false, foreign_key: true
      t.timestamps
    end
  end
end
