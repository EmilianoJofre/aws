class AddMetricsToInvestmentAsset < ActiveRecord::Migration[6.0]
  def change
    add_column :investment_assets, :mtd, :float
    add_column :investment_assets, :recovery_level, :float
    add_column :investment_assets, :qtd, :float
    add_column :investment_assets, :ytd, :float
    add_column :investment_assets, :y1, :float
    add_column :investment_assets, :y3, :float
    add_column :investment_assets, :y5, :float
  end
end
