class ReportForSubAccount < PowerTypes::Command.new(:sub_account)
  def perform
    report = { accumulated: {
      current: {
        profit_absolute: 0,
        profit_relative: 0
      }
    } }
    now = Time.current
    (now.month - 1).times do |month|
      date = Time.zone.local(now.year, month + 1, 1)
      report[month + 1] = report_for_month(date)
      report[:accumulated][:current][:profit_absolute] += profit_absolute(date)
      report[:accumulated][:current][:profit_relative] += profit_relative(date)
    end
    report[:accumulated][:last] = last_year_accumulated(now)
    report
  end

  private

  def report_for_month(date)
    {
      initial_capital: initial_capital(date),
      end_capital: end_capital(date),
      profit_absolute: profit_absolute(date),
      profit_relative: profit_relative(date),
      deposits: deposits_sum(date),
      withdrawals: withdrawals_sum(date)
    }
  end

  def currency_symbol
    @currency_symbol ||= @sub_account.currency.to_sym
  end

  def initial_capital(date)
    @sub_account.balance(date.beginning_of_month)[currency_symbol]
  end

  def end_capital(date)
    @sub_account.balance(date.end_of_month)[currency_symbol]
  end

  def wallet_total(date)
    @sub_account.wallet(date.end_of_month) - @sub_account.wallet(date.beginning_of_month)
  end

  def profit_absolute(date)
    end_capital(date) - initial_capital(date) - wallet_total(date)
  end

  def profit_relative(date)
    capital_and_wallet = initial_capital(date) + wallet_total(date)
    if capital_and_wallet != 0
      profit_absolute(date) / capital_and_wallet
    else
      0
    end
  end

  def deposits_sum(date)
    @sub_account.wallet_deposits.where(
      date: date.beginning_of_month...(date.end_of_month + 1.day)
    ).reduce(0) do |sum, deposit|
      sum + deposit.amount
    end
  end

  def withdrawals_sum(date)
    @sub_account.wallet_withdrawals.where(
      date: date.beginning_of_month...(date.end_of_month + 1.day)
    ).reduce(0) { |sum, deposit| sum + deposit.amount }
  end

  def last_year_accumulated(now)
    last_year = Time.zone.local(now.year - 1).beginning_of_year
    end_capital =  end_capital(last_year.end_of_year)
    initial_capital = initial_capital(last_year)
    total_deposits = @sub_account.wallet(last_year) - @sub_account.wallet(last_year.end_of_year)
    profit_absolute = end_capital - initial_capital - total_deposits
    profit_relative = initial_capital != 0 ? (profit_absolute / initial_capital) : 0
    {
      profit_absolute: profit_absolute,
      profit_relative: profit_relative,
      end_capital: end_capital
    }
  end
end
