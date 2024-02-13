class Api::V1::DemoRelationFileSerializer < Api::V1::BaseSerializer
  attributes(
    :id, :relation, :account, :sub_account, :bank,
    :name, :date, :document_type, :file_name, :file_url
  )
end
