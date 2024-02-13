class CreateExternalValueChanges < ActiveRecord::Migration[6.0]
  def change
    create_table :external_value_changes do |t|
      t.references :membership, null: false, foreign_key: true
      t.float :total_value
      t.date :date
      t.string :valuer
      t.integer :type_valuer

      t.timestamps
    end
  end
end
