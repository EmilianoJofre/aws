class Api::V1::RelationFileSerializer < Api::V1::BaseSerializer
  attributes(
    :id, :relation, :account, :sub_account, :bank,
    :name, :date, :document_type, :file_name, :file_url
  )

  def file_name
    object.file['filename'] if object.file
  end

  def file_url
    object.file&.url(expires_in: ENV.fetch('DOCUMENT_URL_EXPIRATION', 300).to_i)
  end
end
