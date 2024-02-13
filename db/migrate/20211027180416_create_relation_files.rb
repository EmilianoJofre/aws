class CreateRelationFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :relation_files do |t|
      t.references :relation, null: false, foreign_key: true
      t.references :account, null: true, foreign_key: true
      t.references :sub_account, null: true, foreign_key: true
      t.references :bank, null: true, foreign_key: true
      t.string :name
      t.date :date
      t.integer :type
      t.jsonb :file_data

      t.timestamps
    end
  end
end
