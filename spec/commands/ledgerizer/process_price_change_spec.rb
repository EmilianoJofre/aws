require 'rails_helper'

describe Ledgerizer::ProcessPriceChange do
  let!(:user) { create(:user) }
  let(:relation) { create(:relation, user_id: user.id) }
  let(:account) { create(:account, relation_id: relation.id) }
  let(:sub_account) { create(:sub_account, account_id: account.id, currency: 'USD') }
  let!(:asset) { create(:investment_asset) }
  let(:price_change) { create(:price_change, investment_asset: asset, value: 1000) }
  let(:quotas_balance) { 100 }

  def perform
    described_class.for(price_change: price_change)
  end

  before do
    allow(Ledgerizer::ProcessInvestmentIncomes).to receive(:for)
    allow(Ledgerizer::ProcessInvestmentExpenses).to receive(:for)
    allow_any_instance_of(Membership).to receive(:quotas_balance).and_return(quotas_balance)
  end

  context 'without memberships' do
    before { perform }

    it { expect(Ledgerizer::ProcessInvestmentIncomes).not_to have_received(:for) }
    it { expect(Ledgerizer::ProcessInvestmentExpenses).not_to have_received(:for) }
  end

  context 'with memberships' do
    let!(:membership) do
      create(:membership, investment_asset_id: asset.id, sub_account_id: sub_account.id)
    end

    context 'with nil quotas balance' do
      let(:quotas_balance) { nil }

      before { perform }

      it { expect(Ledgerizer::ProcessInvestmentIncomes).not_to have_received(:for) }
      it { expect(Ledgerizer::ProcessInvestmentExpenses).not_to have_received(:for) }
    end

    context 'with zero quotas balance' do
      let(:quotas_balance) { 0 }

      before { perform }

      it { expect(Ledgerizer::ProcessInvestmentIncomes).not_to have_received(:for) }
      it { expect(Ledgerizer::ProcessInvestmentExpenses).not_to have_received(:for) }
    end

    context 'with incomes' do
      before do
        allow_any_instance_of(Membership).to receive(:updated_quota_average_price).and_return(900)
        perform
      end

      it { expect(Ledgerizer::ProcessInvestmentIncomes).to have_received(:for) }
      it { expect(Ledgerizer::ProcessInvestmentExpenses).not_to have_received(:for) }
    end

    context 'with expenses' do
      before do
        allow_any_instance_of(Membership).to receive(:updated_quota_average_price).and_return(1100)
        perform
      end

      it { expect(Ledgerizer::ProcessInvestmentExpenses).to have_received(:for) }
      it { expect(Ledgerizer::ProcessInvestmentIncomes).not_to have_received(:for) }
    end

    context 'without changes' do
      before do
        allow_any_instance_of(Membership).to receive(:updated_quota_average_price).and_return(1000)
        perform
      end

      it { expect(Ledgerizer::ProcessInvestmentIncomes).not_to have_received(:for) }
      it { expect(Ledgerizer::ProcessInvestmentExpenses).not_to have_received(:for) }
    end
  end
end
