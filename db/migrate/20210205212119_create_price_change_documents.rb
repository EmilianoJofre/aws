class CreatePriceChangeDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :price_change_documents do |t|
      t.references :price_change, null: false, foreign_key: true
      t.references :membership, null: false, foreign_key: true

      t.timestamps
    end
  end
end
