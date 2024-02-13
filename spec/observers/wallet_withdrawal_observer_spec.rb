require 'rails_helper'

describe WalletWithdrawalObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, withdrawal)
  end

  let(:withdrawal) { create(:wallet_withdrawal) }

  context "when a wallet withdrawal is created" do
    before do
      allow(ProcessWalletWithdrawalJob).to receive(:perform_later)
    end

    it 'calls process movement job' do
      trigger(:after, :create)
      expect(ProcessWalletWithdrawalJob).to have_received(:perform_later).once.with(
        withdrawal
      )
    end
  end
end
