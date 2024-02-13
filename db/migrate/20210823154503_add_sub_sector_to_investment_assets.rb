class AddSubSectorToInvestmentAssets < ActiveRecord::Migration[6.0]
  def change
    add_column :investment_assets, :sub_sector, :string
  end
end
