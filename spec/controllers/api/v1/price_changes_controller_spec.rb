RSpec.describe Api::V1::PriceChangesController, type: :controller do
  describe 'post price change' do
    let(:user) { create(:user) }
    let(:asset) { create(:investment_asset) }

    def create_price_change
      post :create, params: {
        value: 100,
        investment_asset_id: asset.id,
        format: :json
      }
    end

    context 'with signed user, create price change' do
      before do
        sign_in user
        create_price_change
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user, post price change' do
      before do
        create_price_change
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
