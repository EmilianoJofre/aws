class CreateLiabilities < ActiveRecord::Migration[6.0]
  def change
    create_table :liabilities do |t|
      t.references :membership, null: false, foreign_key: true
      t.references :investment_asset, null: true, foreign_key: true
      
      t.string :name
      t.text :description

      t.float :initial_debt
      t.float :debt_participation

      t.integer :total_fees
      t.integer :fees_paid
      t.integer :outstanding_balance

      t.date :start_date
      t.date :end_date
      t.integer :payment_cycle

      t.float :rate
      t.string :rate_description
      t.integer :rate_type
      
      t.timestamps
    end
  end
end
