RSpec.describe Api::V1::RelationsController, type: :controller do
  describe 'get relations' do
    let(:user) { create(:user) }

    def get_relations
      get :index, params: {
        user_id: user.id,
        format: :json
      }
    end

    context 'with user, fetch relations' do
      before do
        sign_in user
        get_relations
      end

      it 'returns successful response for user' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'get investments' do
    let(:relation) { create(:relation) }

    def get_investments
      get :get_investments, params: {
        relation_id: relation.id,
        format: :json
      }
    end

    context 'with user, fetch relations' do
      before do
        sign_in relation
        get_investments
      end

      it 'returns successful response for relation' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'post relation' do
    let(:user) { create(:user) }

    def create_relation
      post :create, params: {
        first_name: 'nombre',
        last_name: 'apellido',
        phone: '123455667',
        rut: '123456-1',
        email: email,
        format: :json
      }
    end

    context 'with invalid params, create relation' do
      let(:email) { '' }

      before do
        sign_in user
        create_relation
      end

      it 'returns invalid response' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'with valid params, create relation' do
      let(:email) { 'some@email.com' }

      before do
        sign_in user
        create_relation
      end

      it 'returns invalid response' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'update chart' do
    let(:user) { create(:user) }
    let(:relation) { create(:relation, user: user) }

    def update_chart
      put :queue_chart_update, params: {
        relation_id: relation.id,
        format: :json
      }
    end

    context 'with user, update chart' do
      before do
        sign_in user
        update_chart
      end

      it 'returns successful response for user' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with relation, update chart' do
      before do
        sign_in relation
        update_chart
      end

      it 'returns unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'without relation or user, update chart' do
      before do
        update_chart
      end

      it 'returns unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
