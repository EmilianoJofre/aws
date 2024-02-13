class AddDeletedByIdToMoneyMovements < ActiveRecord::Migration[6.0]
  def change
    add_column :money_movements, :deleted_by_id, :integer
  end
end
