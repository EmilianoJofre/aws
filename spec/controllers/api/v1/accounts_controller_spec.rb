RSpec.describe Api::V1::AccountsController, type: :controller do
  describe 'get accounts' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let!(:account) { create(:account, relation_id: relation.id) }

    def get_accounts
      get :index, params: {
        relation_id: relation.id,
        format: :json
      }
    end

    context 'with signed user, fetch accounts' do
      before do
        sign_in user
        get_accounts
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user, fetch accounts' do
      before do
        get_accounts
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'post account' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let(:bank) { create(:bank) }

    def post_account
      post :create, params: {
        name: 'account 1',
        rut: '1234567-1',
        email: 'some@email.com',
        relation_id: relation.id,
        bank_id: bank.id,
        format: :json
      }
    end

    context 'with signed user, create account' do
      before do
        sign_in user
        post_account
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user, post account' do
      before do
        post_account
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
