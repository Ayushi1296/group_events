require 'rails_helper'

RSpec.describe GroupEvent, type: :model do
  describe 'associations' do
    subject { create(:group_event) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { create(:group_event) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_numericality_of(:duration).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:zipcode).only_integer.allow_nil }

    describe 'validates check_valid_start_and_end_dates' do
      context 'when end_date < start_date' do
        it 'gives error response' do
          group_event = build(:group_event, end_date: Date.today, start_date: Date.today + 5.days)
          expect(group_event.valid?).to be_falsey
          expect(group_event.errors.messages[:end_date]).to include('should be greater than the start_date')
        end
      end
    end
  end

  describe '#create' do
    context 'callback: set_status_to_draft' do
      it 'defaults status to draft' do
        group_event = build(:group_event)
        group_event.save!
        expect(group_event.draft?).to be_truthy
      end
    end
  end

  describe '#save' do
    context 'callback: set_dates_and_duration' do
      it 'calculates duration if start_date & end_date present' do
        group_event = build(:group_event, end_date: Date.today + 5, start_date: Date.today)
        group_event.save!
        expect(group_event.duration).to eq(5)
      end
      it 'calculates end_date if duration & start_date present' do
        group_event = build(:group_event, start_date: Date.today, duration: 7)
        group_event.save!
        expect(group_event.end_date).to eq(Date.today + 7)
      end
      it 'calculates start_date if duration & end_date present' do
        group_event = build(:group_event, end_date: Date.today + 10, duration: 10)
        group_event.save!
        expect(group_event.start_date).to eq(Date.today)
      end
    end
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values({ draft: 'Draft', published: 'Published' }).backed_by_column_of_type(:string) }
  end

  describe 'publish!' do
    context 'when all values are present' do
      it 'publishes the group event' do
        group_event = build(:group_event, start_date: Date.today, duration: 7, end_date: Date.today + 7)
        group_event.save!
        expect(group_event.publish!).to be_truthy
      end
    end

    context 'when all values are not present' do
      it 'gives an error' do
        group_event = build(:group_event, end_date: Date.today + 7)
        group_event.save!
        expect(group_event.publish!).to be_falsey
      end
    end
  end
end
