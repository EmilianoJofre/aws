require 'rails_helper'

describe Ledgerizer::ProcessMoneyMovement do
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
      movement_type: operation_type,
      average_price: 100,
      quotas: 10,
      membership_id: membership.id,
      sub_account_id: sub_account.id,
      date: now
    )
  end

  def perform
    described_class.for(money_movement: money_movement)
  end

  context "with sale operation_type" do
    let(:operation_type) { 'sale' }

    before do
      allow(Ledgerizer::ExecuteWithdrawal).to receive(:for)
      allow(Ledgerizer::ProcessUserQuotaWithdrawal).to receive(:for)
      allow(money_movement).to receive(:user).and_return(user)
    end

    it "calls correct commands" do
      perform
      expect(Ledgerizer::ExecuteWithdrawal).to have_received(:for).once.with(
        user: user,
        money_movement: money_movement
      )
      expect(Ledgerizer::ProcessUserQuotaWithdrawal).to have_received(:for).once
    end
  end

  context "with purchase operation_type" do
    let(:operation_type) { 'purchase' }

    before do
      allow(Ledgerizer::ProcessUserMoneyInvestment).to receive(:for)
      allow(Ledgerizer::ProcessUserQuotaInvestment).to receive(:for)
      allow(money_movement).to receive(:user).and_return(user)
    end

    it "calls correct commands" do
      perform
      expect(Ledgerizer::ProcessUserMoneyInvestment).to have_received(:for).once.with(
        user: user,
        money_movement: money_movement
      )
      expect(Ledgerizer::ProcessUserQuotaInvestment).to have_received(:for).once
    end
  end
end
