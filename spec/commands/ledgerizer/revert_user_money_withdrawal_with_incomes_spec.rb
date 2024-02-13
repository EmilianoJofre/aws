require 'rails_helper'

describe Ledgerizer::RevertUserMoneyWithdrawalWithIncomes do
  let(:now) { '1984-06-04 09:00:00 UTC'.to_datetime }
  let!(:user) { create(:user) }
  let(:relation) { create(:relation, user_id: user.id) }
  let(:account) { create(:account, relation_id: relation.id) }
  let(:sub_account) { create(:sub_account, account_id: account.id, currency: currency) }
  let!(:asset) { create(:investment_asset) }
  let(:membership) do
    create(:membership, investment_asset_id: asset.id, sub_account_id: sub_account.id)
  end

  let!(:money_movement) do
    create(
      :money_movement,
      quotas: quotas,
      average_price: average_price,
      membership_id: membership.id,
      sub_account_id: sub_account.id,
      date: now
    )
  end

  let(:expected_entry) do
    {
      entry_code: :revert_money_withdrawal_with_incomes,
      entry_time: now,
      document: money_movement
    }
  end

  let(:expected_line_1) do
    {
      account_name: :sub_account_invested_capital,
      accountable: sub_account,
      amount: expected_amount_1
    }
  end

  let(:expected_line_2) do
    {
      account_name: :investment_incomes,
      accountable: membership,
      amount: expected_amount_2
    }
  end

  let(:expected_line_3) do
    {
      account_name: :amount_updated,
      accountable: membership,
      amount: expected_amount_3
    }
  end

  let(:expected_line_4) do
    {
      account_name: :sub_account_capital,
      accountable: sub_account,
      amount: expected_amount_4
    }
  end

  let(:expected_line_5) do
    {
      account_name: :amount_invested,
      accountable: membership,
      amount: expected_amount_5
    }
  end

  def perform
    described_class.for(user: user, money_movement: money_movement)
  end

  before do
    allow(money_movement).to receive(:membership).and_return(membership)
    allow(membership).to receive(:quota_average_price).and_return(quotas_average_price)
    Timecop.freeze(now)
  end

  context "with valid data" do
    let(:currency) { 'USD' }
    let(:quotas) { 10 }
    let(:average_price) { 15 }
    let(:quotas_average_price) { 10 }
    let(:invested_amount) { quotas_average_price * quotas }
    let(:expected_amount_1) {  Money.from_amount(invested_amount, currency) }
    let(:expected_amount_2) do
      Money.from_amount(((quotas * average_price) - invested_amount), currency)
    end
    let(:expected_amount_3) {  Money.from_amount((quotas * average_price), currency) }
    let(:expected_amount_4) {  Money.from_amount(invested_amount, currency) }
    let(:expected_amount_5) {  Money.from_amount(invested_amount, currency) }

    before { perform }

    it { expect(user).to have_ledger_entry(expected_entry) }
    it { expect(user.entries.last).to have_ledger_line(expected_line_1) }
    it { expect(user.entries.last).to have_ledger_line(expected_line_2) }
    it { expect(user.entries.last).to have_ledger_line(expected_line_3) }
    it { expect(user.entries.last).to have_ledger_line(expected_line_4) }
    it { expect(user.entries.last).to have_ledger_line(expected_line_5) }
  end
end
