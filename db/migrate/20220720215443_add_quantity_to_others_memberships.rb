class AddQuantityToOthersMemberships < ActiveRecord::Migration[6.0]
  def change
    add_column :others_memberships, :quantity, :integer
  end
end
