class AddInitialInvestmentToInsurances < ActiveRecord::Migration[6.0]
  def change
    add_column :insurances, :initial_investment, :float
  end
end
