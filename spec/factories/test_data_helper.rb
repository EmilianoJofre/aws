module TestData
  module_function

  def get_data(mime_type, extension = nil)
    extension = mime_type.split('/')[1] if extension.nil?

    attacher = Shrine::Attacher.new
    attacher.set(uploaded_document(mime_type, extension))

    attacher.data # or attacher.data in case of postgres jsonb column
  end

  def uploaded_document(mime_type, extension)
    file = File.open("spec/files/test.#{extension}", binmode: true)

    # for performance we skip metadata extraction and assign test metadata
    uploaded_file = Shrine.upload(file, :store, metadata: false)
    uploaded_file.metadata.merge!(
      size: File.size(file.path),
      mime_type: mime_type,
      filename: "test.#{extension}"
    )

    uploaded_file
  end
end
