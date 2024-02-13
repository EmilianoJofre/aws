class CreateInvestmentAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :investment_assets do |t|
      t.string :name, null: false
      t.string :asset_id, null: false
      t.integer :currency, null: false

      t.timestamps
    end
    add_index :investment_assets, :asset_id, unique: true
  end
end
