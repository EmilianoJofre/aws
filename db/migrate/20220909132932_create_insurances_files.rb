class CreateInsurancesFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :insurance_files do |t|
      t.references :insurance
      t.jsonb :file_data
      
    end

    safety_assured { remove_column :insurances, :insurance_document_id }
    add_column :insurances, :insurance_file_id, :bigint
  end
end
