class AddCommentToWalletWithdrawal < ActiveRecord::Migration[6.0]
  def change
    add_column :wallet_withdrawals, :comment, :string
  end
end
