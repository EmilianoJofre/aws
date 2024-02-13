require 'rails_helper'

RSpec.describe Membership, type: :model do
  it 'has a valid factory' do
    expect(build(:membership)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:sub_account) }
    it { is_expected.to belong_to(:investment_asset) }
  end

  describe '#balance' do
    let(:currency) { 'CLP' }
    let(:sub_account) { create(:sub_account, currency: currency) }
    let(:membership) { create(:membership, sub_account_id: sub_account.id) }
    let(:dollar_price) { 100 }
    let!(:dollar) do
      create(:dollar_price, date: 1.business_day.before(Date.current), price: dollar_price)
    end

    context 'with nil amount updated balance' do
      before do
        allow(membership).to receive(:amount_updated_balance).and_return(nil)
      end

      it { expect(membership.balance).to eq({ CLP: 0, USD: 0 }) }
    end

    context 'with amount updated balance' do
      let(:balance) { 100 }

      before do
        allow(membership).to receive(:amount_updated_balance).and_return(balance)
      end

      context 'with CLP currency' do
        it { expect(membership.balance).to eq({ CLP: balance, USD: balance / dollar_price }) }
      end

      context 'with USD currency' do
        let(:currency) { 'USD' }

        it { expect(membership.balance).to eq({ CLP: balance * dollar_price, USD: balance }) }
      end
    end
  end

  describe '#profit' do
    let(:membership) { create(:membership) }
    let(:amount_invested_balance) { 100 }
    let(:amount_updated_balance) { 200 }

    before do
      allow(membership).to receive(:amount_updated_balance).and_return(amount_updated_balance)
      allow(membership).to receive(:amount_invested_balance).and_return(amount_invested_balance)
    end

    it { expect(membership.profit).to eq(amount_updated_balance - amount_invested_balance) }
  end
end
