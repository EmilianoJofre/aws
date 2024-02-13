class AddFeeOutstandingBalanceToMoneyMovement < ActiveRecord::Migration[6.0]
  def change
    add_column :money_movements, :fee_outstanding_balance, :float
  end
end
