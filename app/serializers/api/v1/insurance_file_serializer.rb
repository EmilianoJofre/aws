class Api::V1::InsuranceFileSerializer < Api::V1::BaseSerializer
  attributes(
    :id, :insurance, :file_url
  )

  def file_name
    object.file['filename'] if object.file
  end

  def file_url
    object.file&.url
  end
end
