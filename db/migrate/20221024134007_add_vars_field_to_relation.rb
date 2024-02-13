class AddVarsFieldToRelation < ActiveRecord::Migration[6.0]
  def change
    add_column :relations, :vars, :text
  end
end
