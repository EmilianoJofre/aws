class AddFieldsToRealEstate < ActiveRecord::Migration[6.0]
  def change
    add_column :real_estates, :name, :string, after: :id
    add_column :real_estates, :total_inversion, :integer, after: :name
  end
end
