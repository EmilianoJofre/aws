class ChangePriceChangeValueTypeToFloat < ActiveRecord::Migration[6.0]
  def change
    safety_assured { change_column :price_changes, :value, :float }
  end
end
