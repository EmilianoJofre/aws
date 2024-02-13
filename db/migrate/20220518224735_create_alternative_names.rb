class CreateAlternativeNames < ActiveRecord::Migration[6.0]
  def change
    create_table :alternative_names do |t|
      t.string :name
      t.belongs_to :membership, null: false, foreign_key: true

      t.timestamps
    end
  end
end
