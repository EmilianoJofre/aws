class Ledgerizer::ProcessWalletDeposit < PowerTypes::Command.new(:wallet_movement)
  include Ledgerizer::Execution::Dsl
  include WalletMovementConcern

  def perform
    execute_wallet_deposit_entry(
      tenant: user, document: @wallet_movement, datetime: @wallet_movement.date
    ) do
      debit(account: :wallet, accountable: sub_account, amount: amount)
      credit(account: :account_total_wallet, accountable: account, amount: amount)
      debit(account: :relation_wallet, accountable: relation, amount: amount)
      credit(account: :relation_total_wallet, accountable: relation, amount: amount)
    end
  end
end
