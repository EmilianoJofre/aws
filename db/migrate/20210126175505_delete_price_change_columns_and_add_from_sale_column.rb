class DeletePriceChangeColumnsAndAddFromSaleColumn < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    safety_assured { remove_column :price_changes, :previous_value, :integer }
    safety_assured { remove_column :price_changes, :previous_price_changed_at, :datetime }
    add_reference :price_changes, :money_movement, index: {algorithm: :concurrently}
  end
end
