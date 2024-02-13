# rubocop:disable Layout/LineLength
class Api::V1::RelationFilesController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!

  def index
    respond_with relation_files, root: "relation_files"
  end

  def create
    respond_with create_relation_file
  end

  def update
    authorize relation_file
    relation_file.update!(relation_file_params.except(:relation_id))
    respond_with relation_file
  end

  def destroy
    authorize relation_file
    respond_with relation_file.destroy!
  end

  def download
    authorize relation_file
    send_data relation_file.file.read,
              filename: relation_file.name,
              type: relation_file.file.content_type
  end

  def download_multiple
    authorize files_to_download
    temp_file = Tempfile.new('documents.zip')
    begin
      ZipUtils.generate_zip(urls_to_download, temp_file)
      zip_data = File.read(temp_file.path)
      send_data(zip_data, type: 'application/zip')
    ensure
      temp_file.close
      temp_file.unlink
    end
  end

  private

  def relation
    return @relation if !@relation.nil?
    return current_relation if !current_relation.nil?

    demo? ? DemoRelation.find(params[:relation_id]) : Relation.find(params[:relation_id])
  end

  def relation_files
    return @relation_files if !@relation_files.nil? && return

    demo? ? relation.demo_relation_files.order('date DESC').includes(:account, :sub_account, :bank) : relation.relation_files.order('date DESC').includes(:account, :sub_account, :bank)
  end

  def relation_file
    @relation_file ||= RelationFile.find(params[:id])
  end

  def create_relation_file
    RelationFile.create!(relation_file_params)
  end

  def relation_file_params
    params.permit(
      :file, :name, :relation_id, :account_id, :date,
      :sub_account_id, :bank_id, :document_type
    )
  end

  def files_to_download
    @files_to_download ||= RelationFile.where(id: params[:ids])
  end

  def urls_to_download
    files_to_download.map do |file|
      {
        name: file.name,
        url: file.file.download,
        extension: file.file.metadata['mime_type'].split('/')[1]
      }
    end
  end

  def demo?
    params[:is_demo] == 'true'
  end
end
# rubocop:enable Layout/LineLength
