require 'rails_helper'

RSpec.describe PriceChange, type: :model do
  it 'has a valid factory' do
    expect(build(:price_change)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:investment_asset) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :value }
    it { is_expected.to validate_presence_of :price_changed_at }
  end
end
