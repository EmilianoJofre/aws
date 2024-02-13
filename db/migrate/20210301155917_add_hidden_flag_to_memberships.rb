class AddHiddenFlagToMemberships < ActiveRecord::Migration[6.0]
  def up
    add_column :memberships, :hidden, :boolean
    change_column_default :memberships, :hidden, false
  end

  def down
    remove_column :memberships, :hidden
  end
end
