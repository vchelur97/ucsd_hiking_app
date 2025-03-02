require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    context 'on create' do
      subject { build(:session) }

      it 'does not validate presence of push notification fields' do
        expect(subject).to be_valid
      end
    end

    context 'on update' do
      subject { create(:session) }

      it { should validate_presence_of(:push_endpoint).on(:update) }
      it { should validate_uniqueness_of(:push_endpoint).on(:update) }
      it { should validate_presence_of(:push_p256dh).on(:update) }
      it { should validate_presence_of(:push_auth).on(:update) }
    end
  end

  describe 'factory' do
    it 'has a valid default factory' do
      expect(build(:session)).to be_valid
    end

    it 'creates session with push endpoint' do
      session = create(:session, :with_push_endpoint)
      expect(session.push_endpoint).to be_present
      expect(session.push_p256dh).to be_present
      expect(session.push_auth).to be_present
    end

    it 'creates session without push endpoint' do
      session = create(:session, :without_push_endpoint)
      expect(session.push_endpoint).to be_nil
      expect(session.push_p256dh).to be_nil
      expect(session.push_auth).to be_nil
    end

    context 'updating push notification fields' do
      let(:session) { create(:session) }

      it 'validates presence when updating with push fields' do
        expect do
          session.update!(push_endpoint: 'https://example.com')
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'successfully updates with all required push fields' do
        expect(session.update(
                 push_endpoint: 'https://example.com/endpoint',
                 push_p256dh: 'key123',
                 push_auth: 'auth123'
               )).to be true
      end
    end
  end
end
