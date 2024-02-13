class CreateAdviserRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :adviser_relations do |t|
      t.belongs_to :adviser, null: false, foreign_key: true
      t.belongs_to :relation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
