require 'rails_helper'

RSpec.describe GroupEventsController, type: :controller do
  describe 'GET #index' do
    context 'when there are no group_events' do
      before { GroupEvent.delete_all }
      it 'responds with ok status' do
        get :index
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['data']).to be_kind_of Hash
        expect(response_body['data']['group_events']).to be_kind_of Array
        expect(response_body['data']['group_events']).to be_empty
      end
    end

    context 'when there are group_events' do
      let!(:event) { create(:group_event) }
      it 'responds with ok status' do
        create(:group_event)
        get :index
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['data']).to be_kind_of Hash
        expect(response_body['data']['group_events']).to be_kind_of Array
        expect(response_body['data']['group_events'].length).to be >= 1
      end

      it 'does not show deleted events' do
        group_event = create(:group_event)
        group_event.update(deleted: true)
        get :index
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['data']).to be_kind_of Hash
        expect(response_body['data']['group_events']).to be_kind_of Array
        expect(response_body['data']['group_events'].length).to eq(GroupEvent.not_deleted.count)
      end
    end
  end

  describe 'GET #show' do
    context 'when group_event exists' do
      it 'responds with ok status' do
        group_event = create(:group_event)
        get :show, params: { id: group_event.id }
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['data']).to be_kind_of Hash
        expect(response_body['data']['group_event']).to be_kind_of Hash
      end
    end
    context 'when group_event does not exist' do
      before { GroupEvent.delete_all }
      it 'responds with 404' do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let!(:user) { create(:user) }
      it 'responds with ok status' do
        post :create, params: { group_event: { name: 'Event 1', start_date: Date.today, user_id: user.id } }
        expect(response).to have_http_status(:ok)
      end
    end
    context 'with invalid params' do
      it 'responds with 500' do
        post :create, params: { group_event: { name: 'hello world' } }
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(500)
        expect(response_body['error_message']).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'destroys the group_event' do
      it 'responds with status ok' do
        group_event = create(:group_event)
        delete :destroy, params: { id: group_event.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when the group_event exists' do
      let!(:group_event) { create(:group_event) }
      context 'with valid params' do
        it 'responds with ok status' do
          patch :update, params: { id: group_event.id, group_event: { description: 'Hello World' } }
          expect(response).to have_http_status(:ok)
        end
      end
    end
    context 'when group_event does not exist' do
      before { GroupEvent.delete_all }
      it 'raises 404 error' do
        patch :update, params: { id: 1 }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST #publish' do
    context 'publishes the group_event' do
      let!(:group_event) { create(:group_event, start_date: Date.today, duration: 7, end_date: Date.today + 7) }
      it 'responds with status ok' do
        post :publish, params: { id: group_event.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
