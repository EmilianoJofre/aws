class CreateAums < ActiveRecord::Migration[6.0]
  def change
    create_table :aums do |t|
      t.text :aum

      t.timestamps
    end
    add_index :aums, :created_at
  end
end
