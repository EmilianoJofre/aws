RSpec.describe Api::V1::MoneyMovementsController, type: :controller do
  let(:user) { create(:user) }
  let(:relation) { create(:relation, user_id: user.id) }
  let(:account) { create(:account, relation_id: relation.id) }
  let(:sub_account) { create(:sub_account, account_id: account.id) }
  let(:asset) { create(:investment_asset) }
  let(:membership) do
    create(:membership, investment_asset_id: asset.id, sub_account_id: sub_account.id)
  end
  let(:movement) { create(:money_movement, membership: membership) }

  describe 'money movements index' do
    def get_index
      get :index, params: {
        relation_id: relation.id,
        format: :json
      }
    end

    context 'with signed user' do
      before do
        sign_in user
        get_index
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'with signed relation' do
      before do
        sign_in relation
        get_index
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user or relation' do
      before do
        get_index
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'post money movement' do
    def post_money_movement
      post :create, params: {
        relation_id: relation.id,
        membership_id: membership.id,
        quotas: 100,
        average_price: 100,
        movement_type: movement_type,
        date: Time.current,
        format: :json
      }
    end

    context 'with signed user, create money movement' do
      let(:movement_type) { 'purchase' }

      before do
        sign_in user
        post_money_movement
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'without signed user, create money movement' do
      let(:movement_type) { 'purchase' }

      before do
        post_money_movement
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'with sale operation type' do
      let(:movement_type) { 'sale' }

      context 'with enough quotas balance' do
        before do
          allow_any_instance_of(Membership).to receive(:quotas_balance).and_return(100)
          sign_in user
          post_money_movement
        end

        it { expect(response).to have_http_status(:success) }
      end

      context 'without enough quotas balance' do
        before do
          allow_any_instance_of(Membership).to receive(:quotas_balance).and_return(99)
          sign_in user
          post_money_movement
        end

        it { expect(response).to have_http_status(:bad_request) }
      end
    end
  end

  describe 'destroy money movement' do
    let(:money_movement) { create(:money_movement, membership: membership) }

    def delete_money_movement
      post :destroy, params: {
        id: money_movement.id,
        relation_id: relation.id,
        membership_id: membership.id,
        format: :json
      }
    end

    before do
      allow(Ledgerizer::RevertMoneyMovement).to receive(:for)
    end

    context 'with signed user, destroy money movement' do
      let(:movement_type) { 'purchase' }

      before do
        sign_in user
        delete_money_movement
      end

      it 'responds with success code' do
        expect(response).to have_http_status(:success)
      end

      it 'calls Ledgerizer::RevertMoneyMovement command with correct params' do
        expect(Ledgerizer::RevertMoneyMovement).to have_received(:for).once.with(
          money_movement: money_movement
        )
      end
    end

    context 'without signed user, does not destroy money movement' do
      let(:movement_type) { 'purchase' }

      before do
        delete_money_movement
      end

      it 'responds with unauthorized code' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not calls Ledgerizer::RevertMoneyMovement command' do
        expect(Ledgerizer::RevertMoneyMovement).not_to have_received(:for)
      end
    end
  end

  describe 'edit money movement' do
    let!(:money_movement) { create(:money_movement, membership: membership) }

    def edit_money_movement
      post :update, params: {
        id: money_movement.id,
        relation_id: relation.id,
        membership_id: membership.id,
        quotas: 100,
        average_price: 100,
        movement_type: movement_type,
        date: Time.current,
        format: :json
      }
    end

    before do
      allow(Ledgerizer::RevertMoneyMovement).to receive(
        :for
      ).and_return(!money_movement.deleted_by_id)
    end

    context 'with signed user, edit money movement' do
      let(:movement_type) { 'purchase' }

      before do
        sign_in user
      end

      it 'responds with success code' do
        edit_money_movement
        expect(response).to have_http_status(:success)
      end

      it 'calls Ledgerizer::RevertMoneyMovement command with correct params' do
        edit_money_movement
        expect(Ledgerizer::RevertMoneyMovement).to have_received(:for).once.with(
          money_movement: money_movement
        )
      end

      it 'creates a new money_movement' do
        expect { edit_money_movement }.to change { MoneyMovement.count }.by(1)
      end
    end

    context 'without signed user, does not edit money movement' do
      let(:movement_type) { 'purchase' }

      it 'responds with unauthorized code' do
        edit_money_movement
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not calls Ledgerizer::RevertMoneyMovement command' do
        edit_money_movement
        expect(Ledgerizer::RevertMoneyMovement).not_to have_received(:for)
      end

      it 'does not creates a new money_movement' do
        expect { edit_money_movement }.to change { MoneyMovement.count }.by(0)
      end
    end
  end
end
