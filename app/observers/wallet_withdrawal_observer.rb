class WalletWithdrawalObserver < PowerTypes::Observer
  after_create :process_wallet_withdrawal
  after_update :process_wallet_withdrawal

  def process_wallet_withdrawal
    ProcessWalletWithdrawalJob.perform_later(object)
  end
end
