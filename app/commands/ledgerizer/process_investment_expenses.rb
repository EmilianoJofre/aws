class Ledgerizer::ProcessInvestmentExpenses < PowerTypes::Command.new(
  :user,
  :price_change_document
)
  include Ledgerizer::Execution::Dsl

  def perform
    execute_investment_expense_entry(
      tenant: @user, document: @price_change_document, datetime: price_change.price_changed_at
    ) do
      debit(account: :investment_incomes, accountable: membership, amount: amount)
      credit(account: :amount_updated, accountable: membership, amount: amount)
    end
  end

  private

  def price_change
    @price_change ||= @price_change_document.price_change
  end

  def membership
    @membership ||= @price_change_document.membership
  end

  def amount
    new_amount_updated = price_change.value * membership.quotas_balance(
      price_change.price_changed_at
    )
    amount_updated_difference = membership.amount_updated_balance(
      price_change.price_changed_at
    ) - new_amount_updated
    Money.from_amount(amount_updated_difference.abs, price_change.investment_asset.currency)
  end
end
