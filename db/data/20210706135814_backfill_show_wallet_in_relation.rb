class BackfillShowWalletInRelation < ActiveRecord::Migration[6.0]
  class MigrationRelation< ApplicationRecord
    self.table_name = :relations
  end
  def up
    MigrationRelation.update_all(show_wallet: false)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
