class CreateRealEstates < ActiveRecord::Migration[6.0]
  def change
    create_table :real_estates do |t|
      t.references :membership, null: false, foreign_key: true
      t.string :commune
      t.string :role
      t.string :lat
      t.string :lon
      t.string :location_sql
      t.string :address
      t.string :asset_destination
      t.float :contributions
      t.float :fiscal_appraisal
      t.float :area
      t.float :builded_area
      t.integer :year

      t.timestamps
    end
  end
end
