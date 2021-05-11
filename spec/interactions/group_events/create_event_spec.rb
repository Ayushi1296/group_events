require 'rails_helper'

RSpec.describe GroupEvents::CreateEvent do
  describe '#execute' do
    describe 'successful scenarios' do
      it 'creates GroupEvent' do
        user = create(:user)
        params = prepare_valid_params
        event = described_class.run!(params.merge(user_id: user.id))

        expect(event).to be_a GroupEvent
      end
    end

    describe 'failure scenarios' do
      context 'when invalid params' do
        it "doesn't create GroupEvent" do
          params = prepare_valid_params

          expect do
            described_class.run(params)
          end.not_to change { GroupEvent.count }
        end
      end
    end

    def prepare_valid_params
      {
        name: 'Hello World',
        descriptiom: 'event 1 description'
      }
    end
  end
end
