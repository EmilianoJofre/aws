class AddFromFileToPriceChanges < ActiveRecord::Migration[6.0]
  def change
    add_column :price_changes, :from_file, :boolean, default: false
  end
end
