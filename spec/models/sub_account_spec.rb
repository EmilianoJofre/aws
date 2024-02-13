require 'rails_helper'

RSpec.describe SubAccount, type: :model do
  it 'has a valid factory' do
    expect(build(:sub_account)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:wallet_deposits) }
    it { is_expected.to have_many(:wallet_withdrawals) }
    it { is_expected.to have_many(:investment_assets).through(:memberships) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :currency }
    it { is_expected.to validate_presence_of :sub_account_id }
  end
end
