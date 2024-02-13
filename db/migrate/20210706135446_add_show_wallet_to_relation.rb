class AddShowWalletToRelation < ActiveRecord::Migration[6.0]
  def change
    add_column :relations, :show_wallet, :boolean, default: false
  end
end
