class Ledgerizer::ProcessUserMoneyInvestment < PowerTypes::Command.new(:user, :money_movement)
  include Ledgerizer::Execution::Dsl
  include MoneyMovementConcern

  def perform
    execute_money_investment_entry(
      tenant: @user, document: @money_movement, datetime: @money_movement.date
    ) do
      debit(account: :amount_updated, accountable: membership, amount: amount)
      credit(
        account: :sub_account_capital, accountable: sub_account, amount: amount
      )

      debit(account: :amount_invested, accountable: membership, amount: amount)
      credit(
        account: :sub_account_invested_capital, accountable: sub_account, amount: amount
      )
    end
  end

  private

  def amount
    Money.from_amount(@money_movement.amount, sub_account.currency)
  end
end
