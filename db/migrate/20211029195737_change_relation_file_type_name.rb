class ChangeRelationFileTypeName < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      change_table :relation_files do |t|
        t.rename :type, :document_type
      end
    end
  end
end
