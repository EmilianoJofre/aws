class CreateDollarPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :dollar_prices do |t|
      t.float :price, null: false
      t.datetime :date, null: false
      t.timestamps
    end
    add_index :dollar_prices, :date, unique: true
  end
end
