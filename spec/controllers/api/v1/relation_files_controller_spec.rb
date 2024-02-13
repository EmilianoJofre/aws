RSpec.describe Api::V1::RelationFilesController, type: :controller do
  describe 'POST #create relation file' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let(:bank) { create(:bank) }

    def post_relation_file
      headers = {
        "Content-Type" => 'multipart/form-data'
      }
      request.headers.merge! headers
      file = fixture_file_upload(
        Rails.root.join("spec/fixtures/files/design.pdf"), 'application/pdf'
      )
      post :create, params: {
        name: 'Test File',
        relation_id: relation.id,
        file: file,
        format: :json
      }
    end

    context 'with signed user' do
      before do
        sign_in user
        post_relation_file
      end

      it { expect(response).to have_http_status(:success) }
      it { expect { post_relation_file }.to change { RelationFile.count }.by(1) }
    end

    context 'with relation' do
      before do
        sign_in relation
        post_relation_file
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'without signed user or relation' do
      before do
        post_relation_file
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'GET #index' do
    let(:relation_files_count) { 3 }
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user: user) }
    let!(:relation_files) { create_list(:relation_file, relation_files_count, relation: relation) }

    def get_relation_files
      get :index, params: {
        relation_id: relation.id,
        format: :json
      }
    end

    context 'with signed user' do
      before do
        sign_in user
        get_relation_files
      end

      it { expect(response).to have_http_status(:success) }

      it 'returns correct amount of data in body' do
        expect(JSON.parse(response.body)['relation_files'].count).to be(relation_files_count)
      end

      it 'serializes correctly' do
        response_files = JSON.parse(response.body)['relation_files']
        response_files.each do |file|
          expect(file['file_name']).to eq('test.pdf')
        end
      end
    end

    context 'with signed relation' do
      before do
        sign_in relation
        get_relation_files
      end

      it { expect(response).to have_http_status(:success) }

      it 'returns correct amount of data in body' do
        expect(JSON.parse(response.body)['relation_files'].count).to be(relation_files_count)
      end

      it 'serializes correctly' do
        response_files = JSON.parse(response.body)['relation_files']
        response_files.each do |file|
          expect(file['file_name']).to eq('test.pdf')
        end
      end
    end

    context 'without signed user or relation' do
      before do
        get_relation_files
      end

      it do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let!(:relation_file) { create(:relation_file, relation: relation) }

    def update_relation_file
      headers = {
        "Content-Type" => 'multipart/form-data'
      }
      request.headers.merge! headers
      file = fixture_file_upload(
        Rails.root.join("spec/fixtures/files/design.pdf"), 'application/pdf'
      )
      patch :update, params: {
        id: relation_file.id,
        file: file,
        format: :json
      }
    end

    context 'with signed user' do
      before do
        sign_in user
      end

      it do
        update_relation_file
        expect(response).to have_http_status(:success)
      end

      it 'updates file' do
        expect { update_relation_file }
          .to change { relation_file.reload.file_data['metadata']['filename'] }
          .from('test.pdf').to('design.pdf')
      end

      it 'serializes correctly' do
        update_relation_file
        response_file = JSON.parse(response.body)['relation_file']
        expect(response_file['file_name']).to eq('design.pdf')
      end
    end

    context 'without signed user' do
      before do
        update_relation_file
      end

      it do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let!(:relation_file) { create(:relation_file, relation: relation) }

    def destroy_relation_file
      delete :destroy, params: {
        id: relation_file.id,
        format: :json
      }
    end

    context 'with signed user' do
      before do
        sign_in user
      end

      it do
        destroy_relation_file
        expect(response).to have_http_status(:success)
      end

      it 'deletes file' do
        expect { destroy_relation_file }
          .to change { RelationFile.count }
          .from(1).to(0)
      end
    end

    context 'without signed user' do
      before do
        destroy_relation_file
      end

      it do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not deletes file' do
        expect { destroy_relation_file }
          .not_to(change { RelationFile.count })
      end
    end
  end

  describe 'GET #download' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let!(:relation_file) { create(:relation_file, relation: relation) }

    def download_relation_file
      get :download, params: {
        id: relation_file.id,
        format: :json
      }
    end

    context 'with signed user' do
      before do
        sign_in user
        download_relation_file
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'with signed relation' do
      before do
        sign_in relation
        download_relation_file
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user or relation' do
      before do
        download_relation_file
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'GET #download_multiple' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let!(:relation_files) { create_list(:relation_file, 3, relation: relation) }

    def download_relation_files
      get :download_multiple, params: {
        ids: relation_files.pluck(:id),
        format: :json
      }
    end

    before do
      allow(ZipUtils).to receive(:generate_zip)
    end

    context 'with signed user' do
      before do
        sign_in user
        download_relation_files
      end

      it 'calls GenerateZipFileJob' do
        expect(ZipUtils).to have_received(:generate_zip)
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'with signed relation' do
      before do
        sign_in relation
        download_relation_files
      end

      it 'calls GenerateZipFileJob' do
        expect(ZipUtils).to have_received(:generate_zip)
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user or relation' do
      before do
        download_relation_files
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
