RSpec.describe Api::V1::RelationHistoriesController, type: :controller do
  describe 'update relation history' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user: user) }
    # date with format yyyy-mm-dd
    let(:date) { '20210515' }
    let!(:relation_history) do
      create(
        :relation_history,
        relation: relation,
        balances_values: { Date.parse(date) => 'dummy' }.to_json
      )
    end

    def update_relation_history
      patch :update, params: {
        id: relation_history.id,
        dates_to_remove: [date],
        format: :json
      }
    end

    context 'with user signed in' do
      before do
        sign_in user
        update_relation_history
      end

      it 'returns successful response' do
        expect(response).to have_http_status(:success)
      end

      it 'removes key' do
        relation_history.reload
        expect(JSON.parse(relation_history.balances_values).key?(date)).to be(false)
      end
    end

    context 'with relation signed in' do
      before do
        sign_in relation
        update_relation_history
      end

      it 'returns unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
