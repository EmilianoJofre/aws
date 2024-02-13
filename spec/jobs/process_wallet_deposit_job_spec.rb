require "rails_helper"

RSpec.describe ProcessWalletDepositJob, type: :job do
  let!(:deposit) { create(:wallet_deposit) }

  describe 'perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(deposit) }.to have_enqueued_job(described_class)
    end
  end

  describe "perform_now" do
    before do
      allow(Ledgerizer::ProcessWalletDeposit).to receive(:for)
    end

    it "calls Ledgerizer::ProcessWalletDeposit command" do
      described_class.perform_now(deposit)
      expect(Ledgerizer::ProcessWalletDeposit).to have_received(:for).once
    end
  end
end
