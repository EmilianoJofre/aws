class RelationBalancesForDates < PowerTypes::Command.new(:relation, :from, :to, :step, :version, demo: false)
  def perform
    balances_for_dates = {}
    @to.step(@from, -@step) do |date|
      balances_for_dates[date] = balances(date.end_of_day) if @version == 'v1'
      balances_for_dates[date] = balances_new(date.end_of_day) if @version == 'v2'
    end
    balances_for_dates
  end

  private

  def balances(date)
    balances = { all: {
      balance: { CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, CRC: 0, COP: 0},
      name: I18n.t("activerecord.attributes.relations.all")
    } }
    @relation.relation_accounts.each do |account|
      account_balance = account.balance(date)
      balances[account.id] = account_balance_format(account, account_balance)
      balances[:all][:balance][:CLP] += account_balance[:CLP]
      balances[:all][:balance][:USD] += account_balance[:USD]
      balances[:all][:balance][:EUR] += account_balance[:EUR]
      balances[:all][:balance][:UF] += account_balance[:UF]
      balances[:all][:balance][:MXN] += account_balance[:MXN]
      balances[:all][:balance][:COP] += account_balance[:COP]
      balances[:all][:balance][:CRC] += account_balance[:CRC]
    end
    balances
  end

  def balances_new(date)
    balances = { all: {
      balance: { CLP: 0 },
      name: I18n.t("activerecord.attributes.relations.all")
    } }
    @relation.relation_accounts.each do |account|
      account_balance = account.balance(date)
      balances[account.id] = account_balance_format(account, account_balance)
      balances[:all][:balance][:CLP] += account_balance[:CLP]
    end
    balances
  end

  def account_balance_format(account, balance)
    {
      balance: balance,
      name: account_name(account),
      rut: account_rut(account),
      bank: account_bank(account),
      type: account.account_type
    }
  end

  def account_name(account)
    @demo ? Faker::Name.name : account.name
  end

  def account_rut(account)
    @demo ? Faker::ChileRut.full_rut : account.rut
  end

  def account_bank(account)
    @demo ? Faker::Bank.name : account.bank.name
  end
end
