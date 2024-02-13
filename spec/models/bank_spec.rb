require 'rails_helper'

RSpec.describe Bank, type: :model do
  it 'has a valid factory' do
    expect(build(:bank)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:accounts) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
  end
end
