class AddBeneficiaryToInsurances < ActiveRecord::Migration[6.0]
  def change
    add_column :insurances, :beneficiary, :string
  end
end
