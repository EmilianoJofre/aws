class AddIsCustomToInvestmentAsset < ActiveRecord::Migration[6.0]
  def up
    add_column :investment_assets, :is_custom, :boolean
    change_column_default :investment_assets, :is_custom, false
  end

  def down
    remove_column :investment_assets, :is_custom
  end
end
