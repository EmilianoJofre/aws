require 'rails_helper'

RSpec.describe Account, type: :model do
  it 'has a valid factory' do
    expect(build(:account)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:relation) }
    it { is_expected.to belong_to(:bank) }
    it { is_expected.to have_many(:sub_accounts) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :rut }
  end

  describe '#balance' do
    let(:account) { create(:account) }
    let(:sub_account) { create(:sub_account, account_id: account.id) }
    let(:membership_1) { create(:membership, sub_account_id: sub_account.id) }
    let(:membership_2) { create(:membership, sub_account_id: sub_account.id) }
    let(:balance_1) { { CLP: 100, USD: 100 } }
    let(:balance_2) { { CLP: 200, USD: 200 } }

    before do
      allow(account).to receive(:memberships).and_return([membership_1, membership_2])
      allow(membership_1).to receive(:balance).and_return(balance_1)
      allow(membership_2).to receive(:balance).and_return(balance_2)
    end

    it { expect(account.balance).to eq({ CLP: 300, USD: 300 }) }
  end
end
