RSpec.describe Api::V1::InvestmentAssetsController, type: :controller do
  describe 'post investment asset' do
    let(:user) { create(:user) }

    def post_asset
      post :create, params: {
        name: 'Bitcoin',
        asset_id: 'BTC',
        currency: 'CLP',
        asset_type: 'variable_income',
        format: :json
      }
    end

    context 'with signed user, create asset' do
      before do
        sign_in user
        post_asset
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user, post asset' do
      before do
        post_asset
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'get investment assets' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user: user) }

    def get_assets
      get :index, params: {
        relation_id: relation.id,
        format: :json
      }
    end

    context 'with signed user, get assets' do
      before do
        sign_in user
        get_assets
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'with signed relation, get assets' do
      before do
        sign_in relation
        get_assets
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user or relation, get assets' do
      before do
        get_assets
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
