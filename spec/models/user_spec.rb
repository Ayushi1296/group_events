require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    subject { create(:user) }
    it { is_expected.to have_many(:group_events).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_uniqueness_of(:email) }

    describe 'validates the email format' do
      context 'when invalid email format' do
        it 'gives error response' do
          user = build(:user, email: '999&&.mn')
          expect(user.valid?).to be_falsey
          expect(user.errors.messages[:email].first).to eq 'is invalid'
        end
      end

      context 'when valid email format' do
        it 'gives success response' do
          user = build(:user, email: '999@xyz.mn')
          expect(user.valid?).to be_truthy
          expect(user.errors.messages[:email]).to be_empty
        end
      end
    end
  end
end
