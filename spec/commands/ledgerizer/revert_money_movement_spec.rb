require 'rails_helper'

describe Ledgerizer::RevertMoneyMovement do
  let(:now) { '1984-06-04 09:00:00 UTC'.to_datetime }
  let!(:user) { create(:user) }
  let(:relation) { create(:relation, user_id: user.id) }
  let(:account) { create(:account, relation_id: relation.id) }
  let(:sub_account) { create(:sub_account, account_id: account.id, currency: 'USD') }
  let!(:asset) { create(:investment_asset) }
  let(:membership) do
    create(:membership, investment_asset_id: asset.id, sub_account_id: sub_account.id)
  end

  let(:money_movement) do
    create(
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
      allow(Ledgerizer::ExecuteRevertWithdrawal).to receive(:for)
      allow(Ledgerizer::ProcessUserQuotaInvestment).to receive(:for)
      allow_any_instance_of(Membership).to receive(:quotas_balance).and_return(100)
      allow(money_movement).to receive(:user).and_return(user)
    end

    it "calls correct commands" do
      perform
      expect(Ledgerizer::ExecuteRevertWithdrawal).to have_received(:for).once
      expect(Ledgerizer::ProcessUserQuotaInvestment).to have_received(:for).once
    end

    it 'creates new instance of MoneyMovement' do
      expect { perform }.to change { MoneyMovement.count }.by(1)
    end
  end

  context "with purchase operation_type" do
    let(:operation_type) { 'purchase' }

    before do
      allow(Ledgerizer::ProcessUserMoneyWithdrawalWithoutChanges).to receive(:for)
      allow(Ledgerizer::ProcessUserQuotaWithdrawal).to receive(:for)
      allow_any_instance_of(Membership).to receive(:quotas_balance).and_return(100)
      allow(money_movement).to receive(:user).and_return(user)
    end

    it "calls correct commands" do
      perform
      expect(Ledgerizer::ProcessUserMoneyWithdrawalWithoutChanges).to have_received(:for).once
      expect(Ledgerizer::ProcessUserQuotaWithdrawal).to have_received(:for).once
    end

    it 'creates new instance of MoneyMovement' do
      expect { perform }.to change { MoneyMovement.count }.by(1)
    end
  end
end
