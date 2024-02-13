class AddVarsToVendor < ActiveRecord::Migration[6.0]
  def change
    add_column :vendors, :vars, :text
  end
end
