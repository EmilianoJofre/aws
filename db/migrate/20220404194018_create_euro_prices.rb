class CreateEuroPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :euro_prices do |t|
      t.float :price, null: false
      t.datetime :date, null: false

      t.timestamps
    end
    add_index :euro_prices, :date, unique: true
  end
end
