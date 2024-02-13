require 'rails_helper'

describe Ledgerizer::ProcessUserQuotaInvestment do
  let(:now) { '1984-06-04 09:00:00 UTC'.to_datetime }
  let!(:user) { create(:user) }
  let(:relation) { create(:relation, user_id: user.id) }
  let(:account) { create(:account, relation_id: relation.id) }
  let(:sub_account) { create(:sub_account, account_id: account.id) }
  let!(:asset) { create(:investment_asset) }
  let(:membership) do
    create(:membership, investment_asset_id: asset.id, sub_account_id: sub_account.id)
  end

  let!(:money_movement) do
    create(
      :money_movement,
      quotas: quotas,
      membership_id: membership.id,
      sub_account_id: sub_account.id,
      date: now
    )
  end

  let(:expected_entry) do
    {
      entry_code: :quota_investment,
      entry_time: now,
      document: money_movement
    }
  end

  let(:expected_line_1) do
    {
      account_name: :quotas,
      accountable: membership,
      amount: expected_amount_1
    }
  end

  let(:expected_line_2) do
    {
      account_name: :issued_quotas,
      accountable: asset,
      amount: expected_amount_2
    }
  end

  def perform
    described_class.for(user: user, money_movement: money_movement)
  end

  before { Timecop.freeze(now) }

  context "with valid data" do
    let(:quotas) { 1000 }
    let(:expected_amount_1) {  Money.from_amount(1000, :clp) }
    let(:expected_amount_2) {  Money.from_amount(1000, :clp) }

    before { perform }

    it { expect(user).to have_ledger_entry(expected_entry) }
    it { expect(user.entries.last).to have_ledger_line(expected_line_1) }
    it { expect(user.entries.last).to have_ledger_line(expected_line_2) }
  end
end
