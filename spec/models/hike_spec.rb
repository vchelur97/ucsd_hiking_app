require 'rails_helper'

RSpec.describe Hike, type: :model do
  describe 'validations' do
    context 'when not a draft' do
      subject { build(:hike, :published) }

      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:trailhead_address) }
      it { should validate_presence_of(:suggested_items) }
      it { should validate_presence_of(:length) }
      it { should validate_presence_of(:elevation) }
      it { should validate_presence_of(:duration) }
      it { should validate_presence_of(:route_type) }
      it { should validate_presence_of(:difficulty) }
    end

    context 'when published' do
      subject { build(:hike, :published) }

      it { should validate_presence_of(:short_description) }
    end

    context 'when draft' do
      subject { build(:hike, :draft) }

      it 'does not validate presence of required fields' do
        expect(subject).to be_valid
      end
    end
  end

  describe 'status methods' do
    it 'identifies published hikes' do
      hike = build(:hike, :published)
      expect(hike).to be_published
    end

    it 'identifies draft hikes' do
      hike = build(:hike, :draft)
      expect(hike).to be_draft
    end

    it 'identifies review hikes' do
      hike = build(:hike, :review)
      expect(hike).to be_review
    end
  end

  describe '#date' do
    it 'formats the date correctly' do
      datetime = Time.zone.local(2024, 4, 15, 9, 0)
      hike = build(:hike, datetime: datetime)
      expect(hike.date).to eq('April 15 Monday')
    end

    it 'returns "No date" when datetime is nil' do
      hike = build(:hike, datetime: nil)
      expect(hike.date).to eq('No date')
    end
  end

  describe '#time' do
    it 'formats the time correctly' do
      datetime = Time.zone.local(2024, 4, 15, 9, 0)
      hike = build(:hike, datetime: datetime)
      expect(hike.time).to eq('09:00 AM')
    end

    it 'returns "No time" when datetime is nil' do
      hike = build(:hike, datetime: nil)
      expect(hike.time).to eq('No time')
    end
  end
end
