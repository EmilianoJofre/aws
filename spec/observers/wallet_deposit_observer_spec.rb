require 'rails_helper'

describe WalletDepositObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, deposit)
  end

  let(:deposit) { create(:wallet_deposit) }

  context "when a wallet deposit is created" do
    before do
      allow(ProcessWalletDepositJob).to receive(:perform_later)
    end

    it 'calls process movement job' do
      trigger(:after, :create)
      expect(ProcessWalletDepositJob).to have_received(:perform_later).once.with(
        deposit
      )
    end
  end
end
