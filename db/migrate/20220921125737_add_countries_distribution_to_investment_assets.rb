class AddCountriesDistributionToInvestmentAssets < ActiveRecord::Migration[6.0]
  def change
    add_column :investment_assets, :countries_distribution, :jsonb
  end
end
