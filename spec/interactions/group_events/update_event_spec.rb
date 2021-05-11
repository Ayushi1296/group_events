require 'rails_helper'

RSpec.describe GroupEvents::UpdateEvent do
  describe '#execute' do
    describe 'successful scenarios' do
      it 'updates GroupEvent' do
        group_event = create(:group_event)
        params = prepare_valid_params
        event = described_class.run!(params.merge(group_event: group_event))

        expect(event).to be_a GroupEvent
      end
    end

    describe 'failure scenarios' do
      context 'when record invalid' do
        it "doesn't update GroupEvent" do
          group_event = create(:group_event)
          params = prepare_invalid_params

          expect do
            described_class.run(params.merge(group_event: group_event))
          end.not_to change { GroupEvent.count }
        end
      end
    end

    def prepare_valid_params
      {
        start_end: Date.today,
        duration: 5,
        address: '302 E Elmwood',
        city: 'Burbank',
        country: 'United States'
      }
    end

    def prepare_invalid_params
      {
        start_end: '21',
        duration: 5,
        address: '302 E Elmwood',
        city: 'Burbank',
        country: 'United States'
      }
    end
  end
end
