class AddBalanceAndStatusToMembershipsAccountsAndRelations < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :updated_balance, :decimal, default: 0
    add_column :memberships, :status, :string
    add_column :accounts, :updated_balance, :decimal, default: 0
    add_column :accounts, :status, :string
    add_column :relations, :updated_balance, :decimal, default: 0
    add_column :relations, :status, :string
  end
end
