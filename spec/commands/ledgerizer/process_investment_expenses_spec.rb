require 'rails_helper'

describe Ledgerizer::ProcessInvestmentExpenses do
  let(:now) { '1984-06-04 09:00:00 UTC'.to_datetime }
  let!(:user) { create(:user) }
  let(:relation) { create(:relation, user_id: user.id) }
  let(:account) { create(:account, relation_id: relation.id) }
  let(:sub_account) { create(:sub_account, account_id: account.id) }
  let!(:asset) { create(:investment_asset) }
  let(:membership) do
    create(:membership, investment_asset_id: asset.id, sub_account_id: sub_account.id)
  end

  let(:price_change) do
    create(
      :price_change,
      value: new_value,
      investment_asset_id: asset.id,
      price_changed_at: now
    )
  end

  let(:price_change_document) do
    create(
      :price_change_document,
      price_change: price_change,
      membership: membership
    )
  end

  let(:expected_entry) do
    {
      entry_code: :investment_expense,
      entry_time: now,
      document: price_change_document
    }
  end

  let(:expected_line_1) do
    {
      account_name: :amount_updated,
      accountable: membership,
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

  def perform
    described_class.for(
      user: user,
      price_change_document: price_change_document
    )
  end

  before do
    allow(membership).to receive(:quotas_balance).and_return(10)
    allow(membership).to receive(:amount_updated_balance).and_return(30)
    Timecop.freeze(now)
  end

  context "with valid data" do
    let(:new_value) { 1 }
    let(:currency) { sub_account.currency }
    let(:expected_amount_1) {  Money.from_amount(-20, currency) }
    let(:expected_amount_2) {  Money.from_amount(-20, currency) }

    before { perform }

    it { expect(user).to have_ledger_entry(expected_entry) }
    it { expect(user.entries.last).to have_ledger_line(expected_line_1) }
    it { expect(user.entries.last).to have_ledger_line(expected_line_2) }
  end
end
