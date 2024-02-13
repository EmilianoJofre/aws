class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.references :sub_account, null: false, foreign_key: true
      t.references :investment_asset, null: false, foreign_key: true
      t.timestamps
    end
  end
end
