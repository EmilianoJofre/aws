require 'rails_helper'

describe Ledgerizer::ExecuteWithdrawal do
  let(:now) { '1984-06-04 09:00:00 UTC'.to_datetime }
  let!(:user) { create(:user) }
  let(:relation) { create(:relation, user_id: user.id) }
  let(:account) { create(:account, relation_id: relation.id) }
  let(:sub_account) { create(:sub_account, account_id: account.id, currency: 'USD') }
  let!(:asset) { create(:investment_asset) }
  let(:membership) do
    create(:membership, investment_asset_id: asset.id, sub_account_id: sub_account.id)
  end

  let!(:money_movement) do
    build(
      :money_movement,
      movement_type: 'sale',
      average_price: sale_price,
      quotas: 10,
      membership_id: membership.id,
      sub_account_id: sub_account.id,
      date: now
    )
  end

  let(:updated_quota_average_price) { 100 }
  let(:sale_price) { 100 }
  let(:bought_average_price) { 100 }

  def perform
    described_class.for(
      user: user,
      money_movement: money_movement
    )
  end

  before do
    allow_any_instance_of(Membership).to receive(:quota_average_price).and_return(
      bought_average_price
    )
    allow_any_instance_of(Membership).to receive(:updated_quota_average_price).and_return(
      updated_quota_average_price
    )
    allow(Ledgerizer::ProcessUserMoneyWithdrawalWithoutChanges).to receive(:for)
    allow(Ledgerizer::ProcessUserMoneyWithdrawalWithIncomes).to receive(:for)
    allow(Ledgerizer::ProcessUserMoneyWithdrawalWithExpenses).to receive(:for)
    allow(Ledgerizer::ProcessInvestmentExpenses).to receive(:for)
    allow(Ledgerizer::ProcessInvestmentIncomes).to receive(:for)
  end

  context "with updated_quota_average_price equal to sale_price" do
    it "dont call commands" do
      perform
      expect(Ledgerizer::ProcessInvestmentIncomes).not_to have_received(:for)
      expect(Ledgerizer::ProcessInvestmentExpenses).not_to have_received(:for)
    end
  end

  context "with updated_quota_average_price lower than sale_price" do
    let(:updated_quota_average_price) { 99 }

    it "calls correct commands" do
      perform
      expect(Ledgerizer::ProcessInvestmentIncomes).to have_received(:for).once
      expect(Ledgerizer::ProcessInvestmentExpenses).not_to have_received(:for)
    end
  end

  context "with updated_quota_average_price higher than sale_price" do
    let(:updated_quota_average_price) { 101 }

    it "calls correct commands" do
      perform
      expect(Ledgerizer::ProcessInvestmentExpenses).to have_received(:for).once
      expect(Ledgerizer::ProcessInvestmentIncomes).not_to have_received(:for)
    end
  end

  context "with sale price higher than average price" do
    let(:sale_price) { 101 }

    it "calls correct commands" do
      perform
      expect(Ledgerizer::ProcessUserMoneyWithdrawalWithIncomes).to have_received(:for).once.with(
        user: user,
        money_movement: money_movement
      )
      expect(Ledgerizer::ProcessUserMoneyWithdrawalWithExpenses).not_to have_received(:for)
      expect(Ledgerizer::ProcessUserMoneyWithdrawalWithoutChanges).not_to have_received(:for)
    end
  end

  context "with sale price lower than average price" do
    let(:sale_price) { 99 }

    it "calls correct commands" do
      perform
      expect(Ledgerizer::ProcessUserMoneyWithdrawalWithExpenses).to have_received(:for).once.with(
        user: user,
        money_movement: money_movement
      )
      expect(Ledgerizer::ProcessUserMoneyWithdrawalWithIncomes).not_to have_received(:for)
      expect(Ledgerizer::ProcessUserMoneyWithdrawalWithoutChanges).not_to have_received(:for)
    end
  end

  context "with sale price equal to average price" do
    it "calls correct commands" do
      perform
      expect(Ledgerizer::ProcessUserMoneyWithdrawalWithoutChanges).to have_received(:for).once.with(
        user: user,
        money_movement: money_movement
      )
      expect(Ledgerizer::ProcessUserMoneyWithdrawalWithExpenses).not_to have_received(:for)
      expect(Ledgerizer::ProcessUserMoneyWithdrawalWithIncomes).not_to have_received(:for)
    end
  end
end
