class CreateOthersMembership < ActiveRecord::Migration[6.0]
  def change
    create_table :others_memberships do |t|
      t.references :membership, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.integer :total_investment

      t.timestamps
    end
  end
end
