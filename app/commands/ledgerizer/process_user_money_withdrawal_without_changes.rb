class Ledgerizer::ProcessUserMoneyWithdrawalWithoutChanges < PowerTypes::Command.new(
  :user,
  :money_movement
)
  include Ledgerizer::Execution::Dsl
  include MoneyMovementConcern

  def perform
    execute_money_withdrawal_without_changes_entry(
      tenant: @user, document: @money_movement, datetime: @money_movement.date
    ) do
      debit(
        account: :sub_account_invested_capital, accountable: sub_account,
        amount: Money.from_amount(amount, sub_account.currency)
      )
      credit(
        account: :amount_updated, accountable: membership,
        amount: Money.from_amount(amount, sub_account.currency)
      )

      debit(
        account: :sub_account_capital, accountable: sub_account,
        amount: Money.from_amount(amount, sub_account.currency)
      )
      credit(
        account: :amount_invested, accountable: membership,
        amount: Money.from_amount(amount, sub_account.currency)
      )
    end
  end

  private

  def amount
    @money_movement.amount
  end
end
