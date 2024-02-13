class WalletDepositObserver < PowerTypes::Observer
  after_create :process_wallet_deposit
  after_update :process_wallet_deposit

  def process_wallet_deposit
    ProcessWalletDepositJob.perform_later(object)
  end
end
