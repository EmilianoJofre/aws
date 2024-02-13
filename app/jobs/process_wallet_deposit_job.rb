class ProcessWalletDepositJob < ApplicationJob
  queue_as :default

  def perform(wallet_movement)
    Ledgerizer::ProcessWalletDeposit.for(wallet_movement: wallet_movement)
  end
end
