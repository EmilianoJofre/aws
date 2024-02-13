class AddActiveToAdviser < ActiveRecord::Migration[6.0]
  def change
    add_column :advisers, :active, :boolean, null: false, default: true
  end
end
