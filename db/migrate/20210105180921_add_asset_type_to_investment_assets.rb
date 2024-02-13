class AddAssetTypeToInvestmentAssets < ActiveRecord::Migration[6.0]
  def up
    add_column :investment_assets, :valid_asset, :boolean
    change_column_default :investment_assets, :valid_asset, false
    add_column :investment_assets, :asset_type, :integer
  end

  def down
    remove_column :investment_assets, :valid_asset
    remove_column :investment_assets, :asset_type
  end
end
