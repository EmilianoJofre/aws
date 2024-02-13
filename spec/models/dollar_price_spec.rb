require 'rails_helper'

RSpec.describe DollarPrice, type: :model do
  it 'has a valid factory' do
    expect(build(:dollar_price)).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_presence_of :date }
  end
end
