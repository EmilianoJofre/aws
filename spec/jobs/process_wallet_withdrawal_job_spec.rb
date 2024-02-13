require "rails_helper"

RSpec.describe ProcessWalletWithdrawalJob, type: :job do
  let!(:withdrawal) { create(:wallet_withdrawal) }

  describe 'perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(withdrawal) }.to have_enqueued_job(described_class)
    end
  end

  describe "perform_now" do
    before do
      allow(Ledgerizer::ProcessWalletWithdrawal).to receive(:for)
    end

    it "calls Ledgerizer::ProcessWalletWithdrawal command" do
      described_class.perform_now(withdrawal)
      expect(Ledgerizer::ProcessWalletWithdrawal).to have_received(:for).once
    end
  end
end
