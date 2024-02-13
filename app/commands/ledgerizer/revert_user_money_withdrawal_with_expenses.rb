class Ledgerizer::RevertUserMoneyWithdrawalWithExpenses < PowerTypes::Command.new(
  :user,
  :money_movement
)
  include Ledgerizer::Execution::Dsl
  include MoneyMovementConcern

  def perform
    execute_revert_money_withdrawal_with_expenses_entry(
      tenant: @user, document: @money_movement, datetime: @money_movement.date
    ) do
      credit(
        account: :sub_account_invested_capital, accountable: sub_account,
        amount: Money.from_amount(invested_amount, sub_account.currency)
      )
      debit(
        account: :investment_incomes, accountable: membership,
        amount: Money.from_amount(extra_amount, sub_account.currency)
      )
      debit(
        account: :amount_updated, accountable: membership,
        amount: Money.from_amount(invested_amount - extra_amount, sub_account.currency)
      )

      credit(
        account: :sub_account_capital, accountable: sub_account,
        amount: Money.from_amount(invested_amount, sub_account.currency)
      )
      debit(
        account: :amount_invested, accountable: membership,
        amount: Money.from_amount(invested_amount, sub_account.currency)
      )
    end
  end

  private

  def invested_amount
    (membership.quota_average_price(@money_movement.date) * @money_movement.quotas).round(2)
  end

  def extra_amount
    (invested_amount - @money_movement.amount).round(2)
  end
end
