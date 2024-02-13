class CreateRelationHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :relation_histories do |t|
      t.references :relation, null: false, foreign_key: true
      t.integer :time_window
      t.jsonb :wallet_values, default: {}, null: false
      t.jsonb :balances_values, default: {}, null: false

      t.timestamps
    end
  end
end
