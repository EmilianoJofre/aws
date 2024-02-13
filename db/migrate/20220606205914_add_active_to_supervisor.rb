class AddActiveToSupervisor < ActiveRecord::Migration[6.0]
  def change
    add_column :supervisors, :active, :boolean, null: false, default: true
  end
end
