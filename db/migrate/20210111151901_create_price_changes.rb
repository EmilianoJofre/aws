class CreatePriceChanges < ActiveRecord::Migration[6.0]
  def change
    create_table :price_changes do |t|
      t.integer :previous_value
      t.datetime :previous_price_changed_at
      t.integer :value, null: false
      t.datetime :price_changed_at, null: false
      t.references :investment_asset, null: false, foreign_key: true

      t.timestamps
    end
  end
end
