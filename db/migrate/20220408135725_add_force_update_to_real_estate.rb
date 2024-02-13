class AddForceUpdateToRealEstate < ActiveRecord::Migration[6.0]
  def change
    add_column :real_estates, :force_update, :boolean, :default => false
  end
end
