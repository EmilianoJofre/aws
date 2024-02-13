RSpec.describe Api::V1::SubAccountsController, type: :controller do
  describe 'get sub accounts' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let(:account) { create(:account, relation_id: relation.id) }
    let!(:sub_account) { create(:sub_account, account_id: account.id) }

    def get_sub_accounts
      get :index, params: {
        relation_id: relation.id,
        account_id: account.id,
        format: :json
      }
    end

    def get_custom_memberships
      get :custom_memberships, params: {
        relation_id: relation.id,
        sub_account_id: sub_account.id,
        format: :json
      }
    end

    context 'with signed user, fetch sub accounts' do
      before do
        sign_in user
        get_sub_accounts
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user, fetch sub accounts' do
      before do
        get_sub_accounts
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'with signed user, fetch custom assets' do
      before do
        sign_in user
        get_custom_memberships
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user, fetch custom assets' do
      before do
        get_custom_memberships
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'post sub account' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let(:account) { create(:account, relation_id: relation.id) }

    def post_sub_account
      post :create, params: {
        sub_account_id: 'investment 1',
        currency: 'CLP',
        account_id: account.id,
        relation_id: relation.id,
        format: :json
      }
    end

    context 'with signed user, create sub account' do
      before do
        sign_in user
        post_sub_account
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user, post sub account' do
      before do
        post_sub_account
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'post custom assett' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let(:account) { create(:account, relation_id: relation.id) }
    let(:sub_account) { create(:sub_account, account_id: account.id) }
    let(:name) { 'custom' }

    def post_custom_asset
      post :custom_asset, params: {
        sub_account_id: sub_account.id,
        name: name,
        asset_type: 'alternative_asset',
        currency: 'CLP',
        format: :json
      }
    end

    context 'with signed user, create sub account' do
      before do
        sign_in user
        post_custom_asset
      end

      it do
        expect(response).to have_http_status(:success)
        expect(InvestmentAsset.find_by(asset_id: "custom_#{name}_#{sub_account.id}")).to be_present
        expect(Membership.find_by(sub_account_id: sub_account.id)).to be_present
      end
    end

    context 'without signed user, post sub account' do
      before do
        post_custom_asset
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'search membership' do
    let(:asset) { create(:investment_asset) }
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user_id: user.id) }
    let(:account) { create(:account, relation_id: relation.id) }
    let!(:sub_account) { create(:sub_account, account_id: account.id) }

    def search_membership
      get :membership, params: {
        sub_account_id: sub_account.id,
        name: name,
        investment_asset_id: asset_id,
        format: :json
      }
    end

    context 'without membership' do
      let(:name) { 'custom' }
      let(:asset_id) { nil }

      before do
        sign_in user
        search_membership
      end

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'with custom membership' do
      let(:name) { 'custom' }
      let(:asset_id) { nil }
      let!(:asset) do
        create(:investment_asset, name: "custom_#{name}_#{sub_account.id}")
      end
      let!(:membership) do
        create(
          :membership,
          investment_asset_id: asset.id,
          sub_account_id: sub_account.id
        )
      end

      before do
        allow(InvestmentAsset).to receive(:find_by).with(
          asset_id: "custom_#{name}_#{sub_account.id}"
        ).and_return(asset)
        sign_in user
        search_membership
      end

      it do
        expect(response.body).to include("\"id\":#{membership.id},")
      end
    end

    context 'with normal membership' do
      let(:name) { 'custom' }
      let(:asset_id) { nil }
      let!(:asset) do
        create(:investment_asset, name: "custom_#{name}_#{sub_account.id}")
      end
      let!(:membership) do
        create(
          :membership,
          investment_asset_id: asset.id,
          sub_account_id: sub_account.id
        )
      end

      before do
        allow(Membership).to receive(:find_by).and_return(membership)
        sign_in user
        search_membership
      end

      it do
        expect(response.body).to include("\"id\":#{membership.id},")
      end
    end
  end
end
