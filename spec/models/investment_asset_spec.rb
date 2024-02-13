require 'rails_helper'

RSpec.describe InvestmentAsset, type: :model do
  it 'has a valid factory' do
    expect(build(:investment_asset)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:sub_accounts) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:investment_asset) }

    it { is_expected.to validate_presence_of :currency }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :asset_id }
    it { is_expected.to validate_presence_of :asset_type }
    it { is_expected.to validate_uniqueness_of(:asset_id).case_insensitive }
  end
end
