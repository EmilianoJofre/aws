class AddUpdatedBalanceToSubAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_accounts, :updated_balance, :decimal, default: 0
    add_column :sub_accounts, :status, :string
  end
end
