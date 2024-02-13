class CreateMoneyMovements < ActiveRecord::Migration[6.0]
  def change
    create_table :money_movements do |t|
      t.integer :amount, null: false
      t.integer :quotas, null: false
      t.datetime :date, null: false
      t.references :sub_account, null: false, foreign_key: true
      t.references :membership, null: false, foreign_key: true
      t.timestamps
    end
  end
end
