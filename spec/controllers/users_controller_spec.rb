require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    context 'when there are no users' do
      before { User.delete_all }
      it 'responds with ok status' do
        get :index
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['data']).to be_kind_of Hash
        expect(response_body['data']['users']).to be_kind_of Array
        expect(response_body['data']['users']).to be_empty
      end
    end

    context 'when there are users' do
      it 'responds with ok status' do
        create(:user)
        get :index
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['data']).to be_kind_of Hash
        expect(response_body['data']['users']).to be_kind_of Array
        expect(response_body['data']['users'].length).to be >= 1
      end
    end
  end

  describe 'GET #show' do
    context 'when user exists' do
      let!(:user) { create(:user) }
      it 'responds with ok status' do
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['data']).to be_kind_of Hash
        expect(response_body['data']['user']).to be_kind_of Hash
      end
    end
    context 'when user does not exist' do
      before { User.delete_all }
      it 'responds with 404' do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'responds with ok status' do
        post :create, params: { user: { name: 'hello', email: 'abc@tyu.in' } }
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid params' do
      it 'responds with 500' do
        post :create, params: { user: { name: 'hello world' } }
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(500)
        expect(response_body['error_message']).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'destroys the user' do
      let!(:user) { create(:user) }
      it 'responds with status ok' do
        delete :destroy, params: { id: user.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when the user exists' do
      let!(:user) { create(:user) }
      context 'with valid params' do
        it 'responds with ok status' do
          patch :update, params: { id: user.id, user: { name: 'Joe Ward' } }
          expect(response).to have_http_status(:ok)
        end
      end
      context 'with invalid params' do
        let!(:user) { create(:user) }
        it 'responds with 500 status when blank name provided' do
          patch :update, params: { id: user.id, user: { name: '' } }
          expect(response).to have_http_status(500)
        end
      end
    end
    context 'when user does not exist' do
      before { User.delete_all }
      it 'raises 404 error' do
        patch :update, params: { id: 1 }
        expect(response).to have_http_status(404)
      end
    end
  end
end
