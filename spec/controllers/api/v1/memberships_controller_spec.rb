RSpec.describe Api::V1::MembershipsController, type: :controller do
  let(:user) { create(:user) }
  let(:relation) { create(:relation, user_id: user.id) }
  let(:account) { create(:account, relation_id: relation.id) }
  let(:sub_account) { create(:sub_account, account_id: account.id) }
  let(:asset) { create(:investment_asset) }

  describe 'get memberships' do
    let(:membership) do
      create(:membership, investment_asset_id: asset.id, sub_account_id: sub_account.id)
    end

    def get_memberships
      get :index, params: {
        relation_id: relation.id,
        sub_account_id: sub_account.id,
        format: :json
      }
    end

    context 'with signed user, get memberships' do
      before do
        sign_in user
        get_memberships
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user, get memberships' do
      before do
        get_memberships
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'post membership' do
    def post_membership
      post :create, params: {
        relation_id: relation.id,
        account_id: account.id,
        sub_account_id: sub_account.id,
        investment_asset_id: asset.id,
        format: :json
      }
    end

    context 'with signed user, create membership' do
      before do
        sign_in user
        post_membership
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user, post membership' do
      before do
        post_membership
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'liquidate membership' do
    let(:membership) do
      create(:membership, investment_asset_id: asset.id, sub_account_id: sub_account.id)
    end

    def liquidate
      patch :liquidate, params: {
        membership_id: membership.id,
        format: :json
      }
    end

    context 'with positive balances' do
      before do
        allow_any_instance_of(Membership).to receive(:quotas_balance).and_return(100)
        allow_any_instance_of(Membership).to receive(:updated_quota_average_price).and_return(100)
        sign_in user
        liquidate
      end

      it do
        expect(MoneyMovement.count).to eq(1)
      end
    end

    context 'without balances' do
      before do
        sign_in user
        liquidate
      end

      it do
        expect(MoneyMovement.count).to eq(0)
      end
    end
  end

  describe 'enable membership' do
    let(:membership) do
      create(
        :membership,
        investment_asset_id: asset.id,
        sub_account_id: sub_account.id,
        hidden: true
      )
    end

    def enable
      patch :enable, params: {
        membership_id: membership.id,
        format: :json
      }
    end

    before do
      allow(Membership).to receive(:find).and_return(membership)
      sign_in user
    end

    it do
      expect { enable }.to change { membership.hidden }.from(true).to(false)
    end
  end
end
