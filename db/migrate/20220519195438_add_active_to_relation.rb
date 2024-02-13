class AddActiveToRelation < ActiveRecord::Migration[6.0]
  def change
    add_column :relations, :active, :boolean, null: false, default: true
  end
end
