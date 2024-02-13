require 'rails_helper'

RSpec.describe PriceChangeDocument, type: :model do
  it 'has a valid factory' do
    expect(build(:price_change_document)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:price_change) }
    it { is_expected.to belong_to(:membership) }
  end
end
