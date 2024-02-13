require 'rails_helper'

RSpec.describe WalletWithdrawal, type: :model do
  it 'has a valid factory' do
    expect(build(:wallet_withdrawal)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:sub_account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    it { is_expected.to validate_presence_of :date }
  end
end
