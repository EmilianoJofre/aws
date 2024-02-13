class AddAverageAnnualCostToInvestmentAssets < ActiveRecord::Migration[6.0]
  def change
    add_column :investment_assets, :average_annual_cost, :float
  end
end
