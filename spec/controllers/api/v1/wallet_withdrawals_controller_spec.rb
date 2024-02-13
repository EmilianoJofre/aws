RSpec.describe Api::V1::WalletWithdrawalsController, type: :controller do
  let(:user) { create(:user) }
  let(:relation) { create(:relation, user_id: user.id) }
  let(:account) { create(:account, relation_id: relation.id) }
  let(:sub_account) { create(:sub_account, account_id: account.id) }
  let(:wallet_withdrawal) { create(:wallet_withdrawal, sub_account_id: sub_account.id) }

  it_behaves_like 'wallet_movements'

  describe 'delete wallet withdrawal' do
    def delete_wallet_withdrawal
      delete :destroy, params: {
        sub_account_id: sub_account.id,
        id: wallet_withdrawal.id,
        format: :json
      }
    end

    context 'with signed user' do
      before do
        sign_in user
        delete_wallet_withdrawal
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'with signed relation' do
      before do
        sign_in relation
        delete_wallet_withdrawal
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'with not signed user' do
      before do
        delete_wallet_withdrawal
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'edit wallet withdrawal' do
    def edit_wallet_withdrawal
      patch :update, params: {
        sub_account_id: sub_account.id,
        id: wallet_withdrawal.id,
        format: :json
      }
    end

    context 'with signed user' do
      before do
        sign_in user
        edit_wallet_withdrawal
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'with signed relation' do
      before do
        sign_in relation
        edit_wallet_withdrawal
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'with not signed user' do
      before do
        edit_wallet_withdrawal
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
