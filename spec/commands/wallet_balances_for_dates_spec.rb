require 'rails_helper'

describe WalletBalancesForDates do
  def perform
    described_class.for(relation: relation, from: from, to: to, step: step)
  end

  let(:relation) { create(:relation) }
  let(:account1) { create(:account, relation: relation) }
  let(:account2) { create(:account, relation: relation) }
  let(:to) { Date.current }
  let(:from) { Date.current - 1.day }
  let(:step) { 1 }
  let(:wallets) do
    {
      Date.current - 1.day => {
        all: { CLP: 25, USD: 50 },
        account1.id => { CLP: 10, USD: 20 },
        account2.id => { CLP: 15, USD: 30 }
      },
      Date.current => {
        all: { CLP: 25, USD: 50 },
        account1.id => { CLP: 5, USD: 10 },
        account2.id => { CLP: 20, USD: 40 }
      }
    }
  end

  before do
    allow(relation).to receive(:relation_accounts).and_return([account1, account2])
    allow(relation).to receive(:total_wallet).with(from.end_of_day).and_return({ CLP: 25, USD: 50 })
    allow(account1).to receive(:total_wallet).with(from.end_of_day).and_return({ CLP: 10, USD: 20 })
    allow(account2).to receive(:total_wallet).with(from.end_of_day).and_return({ CLP: 15, USD: 30 })
    allow(relation).to receive(:total_wallet).with(to.end_of_day).and_return({ CLP: 25, USD: 50 })
    allow(account1).to receive(:total_wallet).with(to.end_of_day).and_return({ CLP: 5, USD: 10 })
    allow(account2).to receive(:total_wallet).with(to.end_of_day).and_return({ CLP: 20, USD: 40 })
  end

  it { expect(perform).to eq(wallets) }
end
