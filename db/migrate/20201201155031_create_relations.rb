class CreateRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :relations do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :rut, null: false
      t.string :email, null: false
      t.string :phone
      t.string :person_type, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
