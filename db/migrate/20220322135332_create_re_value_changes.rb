class CreateReValueChanges < ActiveRecord::Migration[6.0]
  def change
    create_table :re_value_changes do |t|
      t.references :real_estate, null: false, foreign_key: true
      t.float :builded_value
      t.float :area_value
      t.float :total_value

      t.timestamps
    end
  end
end
