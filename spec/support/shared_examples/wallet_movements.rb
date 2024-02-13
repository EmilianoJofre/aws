shared_examples 'wallet_movements' do
  describe 'get wallet movements' do
    def get_wallet_movements
      get :index, params: {
        sub_account_id: sub_account.id,
        format: :json
      }
    end

    context 'with signed user, get wallet withdrawals' do
      before do
        sign_in user
        get_wallet_movements
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'with not signed user, get wallet withdrawals' do
      before do
        get_wallet_movements
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'post wallet movement' do
    def post_wallet_movements
      post :create, params: {
        sub_account_id: sub_account.id,
        amount: 1,
        date: '2020-01-01',
        comment: 'test comment',
        format: :json
      }
    end

    context 'with signed user, post wallet withdrawal' do
      before do
        sign_in user
        post_wallet_movements
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'with not signed user, post wallet withdrawal' do
      before do
        post_wallet_movements
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'get month wallet movements' do
    def get_month_movements
      get :month_movements, params: {
        sub_account_id: sub_account.id,
        month: '2020-12-31',
        format: :json
      }
    end

    context 'with signed user, get month movements' do
      before do
        sign_in user
        get_month_movements
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'with signed relation, get month movements' do
      before do
        sign_in relation
        get_month_movements
      end

      it { expect(response).to have_http_status(:success) }
    end

    context 'with not signed user, get month movements' do
      before do
        get_month_movements
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
