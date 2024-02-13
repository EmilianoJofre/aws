class ProcessWalletWithdrawalJob < ApplicationJob
  queue_as :default

  def perform(wallet_movement)
    Ledgerizer::ProcessWalletWithdrawal.for(wallet_movement: wallet_movement)
  end
end
