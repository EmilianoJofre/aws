class InsuranceDocumentUploader < BaseUploader
  def allowed_types
    @allowed_types ||= %w[image/jpeg image/jpg image/png application/pdf].freeze
  end
end