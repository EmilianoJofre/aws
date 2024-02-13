class CreateWalletDeposits < ActiveRecord::Migration[6.0]
  def change
    create_table :wallet_deposits do |t|
      t.references :sub_account, null: false, foreign_key: true
      t.date :date
      t.float :amount

      t.timestamps
    end
  end
end
