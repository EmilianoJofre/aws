class AddCommentToWalletDeposit < ActiveRecord::Migration[6.0]
  def change
    add_column :wallet_deposits, :comment, :string
  end
end
