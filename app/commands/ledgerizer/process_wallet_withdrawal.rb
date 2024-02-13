class Ledgerizer::ProcessWalletWithdrawal < PowerTypes::Command.new(:wallet_movement)
  include Ledgerizer::Execution::Dsl
  include WalletMovementConcern

  def perform
    execute_wallet_withdrawal_entry(
      tenant: user, document: @wallet_movement, datetime: @wallet_movement.date
    ) do
      credit(account: :wallet, accountable: sub_account, amount: amount)
      debit(account: :account_total_wallet, accountable: account, amount: amount)
      credit(account: :relation_wallet, accountable: relation, amount: amount)
      debit(account: :relation_total_wallet, accountable: relation, amount: amount)
    end
  end
end
