class WalletBalancesForDates < PowerTypes::Command.new(:relation, :from, :to, :step)
  def perform
    balances_for_dates = {}
    @to.step(@from, -@step) do |date|
      balances_for_dates[date] = balances(date.end_of_day)
    end
    balances_for_dates
  end

  private

  def balances(date)
    balances = { all: @relation.total_wallet(date) }
    @relation.relation_accounts.each do |account|
      balances[account.id] = account.total_wallet(date)
    end
    balances
  end
end
