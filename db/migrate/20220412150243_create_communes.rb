class CreateCommunes < ActiveRecord::Migration[6.0]
  def change
    create_table :communes do |t|
      t.string :name
      t.integer :code_sii
      t.integer :code_tesoreria

      t.timestamps
    end
  end
end
