require 'rails_helper'
require 'ostruct'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:phone_no).on(:update) }

    context 'phone number format on update' do
      let(:user) { create(:user) }

      it 'is valid with a 10-digit number' do
        user.phone_no = '1234567890'
        expect(user).to be_valid
      end

      it 'is invalid with less than 10 digits' do
        user.phone_no = '123456789'
        expect(user).not_to be_valid
        expect(user.errors[:phone_no]).to include('is invalid')
      end

      it 'is invalid with more than 10 digits' do
        user.phone_no = '12345678901'
        expect(user).not_to be_valid
        expect(user.errors[:phone_no]).to include('is invalid')
      end
    end

    it { should allow_value('email@address.com', 'user.name@domain.com', 'email@subdomain.domain.com').for(:email) }
    it 'is invalid with an invalid email format' do
      user = build(:user, email: 'invalid-email')
      user.valid?
      expect(user.errors[:email]).to include('is invalid')
    end
  end

  describe 'associations' do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_many(:waivers).dependent(:destroy) }
    it { should have_many(:cars).dependent(:destroy) }
    it { should have_many(:hikes).dependent(:destroy) }
    it { should have_many(:hike_cars).through(:cars) }
  end

  describe 'validations' do
    subject { build(:user, email: 'test@example.com', full_name: 'Test User') }
    it { should validate_presence_of(:full_name) }
    it { should validate_length_of(:full_name).is_at_most(50) }
  end

  describe '.create_from_omniauth' do
    let(:auth_hash) do
      OpenStruct.new(
        info: OpenStruct.new(
          email: 'test@ucsd.edu',
          name: 'Test User',
          image: 'http://example.com/image.jpg'
        )
      )
    end

    context 'when user does not exist' do
      it 'creates a new user with correct attributes' do
        user, = described_class.create_from_omniauth(auth_hash)

        expect(user).to be_persisted
        expect(user.email).to eq('test@ucsd.edu')
        expect(user.full_name).to eq('Test User')
        expect(user.avatar_url).to eq('http://example.com/image.jpg')
      end
    end

    context 'when user exists' do
      let!(:existing_user) { create(:user, email: 'test@ucsd.edu', avatar_url: nil) }

      it 'does not create duplicate user' do
        expect do
          described_class.create_from_omniauth(auth_hash)
        end.to change(described_class, :count).by(0)
      end
    end

    context 'when auth_hash is missing email' do
      let(:auth_hash) do
        OpenStruct.new(
          info: OpenStruct.new(
            name: 'Test User',
            image: 'http://example.com/image.jpg'
          )
        )
      end

      it 'does not create a new user' do
        allow(described_class).to receive(:email_verified?).with(nil).and_return(false)
        expect { described_class.create_from_omniauth(auth_hash) }.to raise_error(ArgumentError)
      end
    end

    context 'when auth_hash is missing name' do
      let(:auth_hash) do
        OpenStruct.new(
          info: OpenStruct.new(
            email: 'test@ucsd.edu',
            image: 'http://example.com/image.jpg'
          )
        )
      end

      it 'creates a new user with a default name' do
        user, = described_class.create_from_omniauth(auth_hash)
        expect(user).to be_persisted
        expect(user.full_name).to eq(auth_hash.info.email)
      end
    end
  end

  context 'when auth_hash is missing image' do
    let(:auth_hash) do
      OpenStruct.new(
        info: OpenStruct.new(
          email: 'test@ucsd.edu',
          name: 'Test User'
        )
      )
    end

    it 'creates a new user with a nil avatar_url' do
      user, = described_class.create_from_omniauth(auth_hash)
      expect(user).to be_persisted
      expect(user.avatar_url).to be_nil
    end
  end

  context 'when auth_hash is empty' do
    let(:auth_hash) { OpenStruct.new(info: OpenStruct.new) }

    it 'does not create a new user' do
      allow(described_class).to receive(:email_verified?).with(nil).and_return(false)
      expect { described_class.create_from_omniauth(auth_hash) }.to raise_error(ArgumentError)
    end
  end

  describe '.email_verified?' do
    it 'returns true for UCSD email addresses' do
      expect(described_class.email_verified?('test@ucsd.edu')).to be true
      expect(described_class.email_verified?('test@ucsd.com')).to be true
    end

    it 'returns false for non-UCSD email addresses' do
      expect(described_class.email_verified?('test@example.com')).to be false
    end
  end

  describe 'hikes association' do
    it 'returns all hikes hosted by the user' do
      user = create(:user)
      hike1 = create(:hike, host: user)
      hike2 = create(:hike, host: user)
      expect(user.hikes).to include(hike1, hike2)
    end
  end

  describe 'hike_cars association' do
    it 'returns all hike_cars associated with the user through their cars' do
      user = create(:user)
      car = create(:car, user: user)
      hike_car1 = create(:hike_car, car: car)
      hike_car2 = create(:hike_car, car: car)
      expect(user.hike_cars).to include(hike_car1, hike_car2)
    end
  end

  describe 'role methods' do
    let(:user) { create(:user, :hiker) }
    let(:admin) { create(:user, :admin) }
    let(:hike) { create(:hike, host: user) }

    describe '#admin?' do
      it 'returns true for admin users' do
        expect(admin.admin?).to be true
      end

      it 'returns false for non-admin users' do
        expect(user.admin?).to be false
      end
    end

    describe '#hiker?' do
      it 'returns true for users with hiker role' do
        expect(user.hiker?).to be true
      end

      it 'returns false for users without hiker role' do
        non_hiker = create(:user)
        expect(non_hiker.hiker?).to be false
      end
    end

    describe '#host?' do
      it 'returns true when user is the hike host' do
        expect(user.host?(hike)).to be true
      end
    end
  end

  describe 'access methods' do
    describe '#allowed_site_access?' do
      it 'returns true for UCSD email users' do
        user = create(:user, :hiker)
        expect(user.allowed_site_access?).to be true
      end

      it 'returns true for existing hikers with non-UCSD email' do
        user = create(:user, :hiker, email: "abc@gmail.com")
        expect(user.allowed_site_access?).to be true
      end

      it 'returns false for non-UCSD email without hiker role' do
        user = create(:user, email: "abc@gmail.com")
        expect(user.allowed_site_access?).to be false
      end
    end
  end

  describe 'notification methods' do
    let(:user) { create(:user) }

    describe '#subscribed?' do
      it 'returns true when user is subscribed to the hike' do
        hike = create(:hike, subscribers: [user.id])
        expect(user.subscribed?(hike)).to be true
      end
    end

    describe '#allowed_notifications?' do
      it 'returns true when user has sessions with push endpoints' do
        create(:session, user: user, push_endpoint: 'https://example.com/push')
        expect(user.allowed_notifications?).to be true
      end

      it 'returns false when user has no sessions with push endpoints' do
        create(:session, user: user, push_endpoint: nil)
        expect(user.allowed_notifications?).to be false
      end
    end
  end
end
