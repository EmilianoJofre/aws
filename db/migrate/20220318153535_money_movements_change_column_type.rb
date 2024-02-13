class MoneyMovementsChangeColumnType < ActiveRecord::Migration[6.0]
  def change
    StrongMigrations.disable_check(:change_column)
    change_column :money_movements, :quotas, :float
  end
end
