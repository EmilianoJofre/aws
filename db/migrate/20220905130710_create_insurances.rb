class CreateInsurances < ActiveRecord::Migration[6.0]
  def change
    create_table :insurances do |t|
      t.references :membership, null: false, foreign_key: true
      t.string :name
      t.string :insuree
      t.text :details
      t.float :prime
      t.float :insured_capital
      t.integer :insurance_document_id
      t.datetime :policy_end
      t.datetime :policy_renovation

      t.timestamps

    end
  end
end
