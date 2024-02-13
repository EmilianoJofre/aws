class AddFeeToMoneyMovement < ActiveRecord::Migration[6.0]
  def change
    add_column :money_movements, :fee_number, :integer
  end
end
