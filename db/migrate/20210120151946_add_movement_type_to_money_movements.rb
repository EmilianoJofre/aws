class AddMovementTypeToMoneyMovements < ActiveRecord::Migration[6.0]
  def change
    add_column :money_movements, :movement_type, :integer
    add_column :money_movements, :average_price, :float
    safety_assured { remove_column :money_movements, :amount }
  end
end
