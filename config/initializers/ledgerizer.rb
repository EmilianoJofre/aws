require_relative 'money'

LEDGERIZER_CURRENCIES = %w{
  CLP
  USD
  EUR
  UF
  MXN
  COP
  CRC
}

Ledgerizer.setup do |conf|
  conf.tenant(:user, currency: :clp) do
    conf.asset :quotas
    conf.asset :amount_invested, currencies: LEDGERIZER_CURRENCIES
    conf.asset :amount_updated, currencies: LEDGERIZER_CURRENCIES
    conf.asset :wallet, currencies: LEDGERIZER_CURRENCIES
    conf.asset :relation_wallet, currencies: LEDGERIZER_CURRENCIES
    conf.income :investment_incomes, currencies: LEDGERIZER_CURRENCIES
    conf.liability :account_total_wallet, currencies: LEDGERIZER_CURRENCIES
    conf.liability :relation_total_wallet, currencies: LEDGERIZER_CURRENCIES
    conf.liability :issued_quotas
    conf.liability :sub_account_capital, currencies: LEDGERIZER_CURRENCIES
    conf.liability :sub_account_invested_capital, currencies: LEDGERIZER_CURRENCIES

    conf.entry :wallet_deposit, document: :wallet_deposit  do
      conf.debit account: :wallet, accountable: :sub_account
      conf.credit account: :account_total_wallet, accountable: :account
      conf.debit account: :relation_wallet, accountable: :relation
      conf.credit account: :relation_total_wallet, accountable: :relation
    end

    conf.entry :wallet_withdrawal, document: :wallet_withdrawal  do
      conf.debit account: :account_total_wallet, accountable: :account
      conf.credit account: :wallet, accountable: :sub_account
      conf.debit account: :relation_total_wallet, accountable: :relation
      conf.credit account: :relation_wallet, accountable: :relation
    end

    conf.entry :money_investment, document: :money_movement do
      conf.debit account: :amount_updated, accountable: :membership
      conf.credit account: :sub_account_capital, accountable: :sub_account

      conf.debit account: :amount_invested, accountable: :membership
      conf.credit account: :sub_account_invested_capital, accountable: :sub_account
    end

    conf.entry :quota_investment, document: :money_movement do
      conf.debit account: :quotas, accountable: :membership
      conf.credit account: :issued_quotas, accountable: :investment_asset
    end

    conf.entry :quota_withdrawal, document: :money_movement do
      conf.debit account: :issued_quotas, accountable: :investment_asset
      conf.credit account: :quotas, accountable: :membership
    end

    conf.entry :investment_income, document: :price_change_document do
      conf.debit account: :amount_updated, accountable: :membership
      conf.credit account: :investment_incomes, accountable: :membership
    end

    conf.entry :investment_expense, document: :price_change_document do
      conf.debit account: :investment_incomes, accountable: :membership
      conf.credit account: :amount_updated, accountable: :membership
    end

    conf.entry :money_withdrawal_with_incomes, document: :money_movement do
      conf.debit account: :sub_account_invested_capital, accountable: :sub_account
      conf.debit account: :investment_incomes, accountable: :membership
      conf.credit account: :amount_updated, accountable: :membership

      conf.debit account: :sub_account_capital, accountable: :sub_account
      conf.credit account: :amount_invested, accountable: :membership
    end

    conf.entry :money_withdrawal_with_expenses, document: :money_movement do
      conf.debit account: :sub_account_invested_capital, accountable: :sub_account
      conf.credit account: :investment_incomes, accountable: :membership
      conf.credit account: :amount_updated, accountable: :membership

      conf.debit account: :sub_account_capital, accountable: :sub_account
      conf.credit account: :amount_invested, accountable: :membership
    end

    conf.entry :revert_money_withdrawal_with_incomes, document: :money_movement do
      conf.credit account: :sub_account_invested_capital, accountable: :sub_account
      conf.credit account: :investment_incomes, accountable: :membership
      conf.debit account: :amount_updated, accountable: :membership

      conf.credit account: :sub_account_capital, accountable: :sub_account
      conf.debit account: :amount_invested, accountable: :membership
    end

    conf.entry :revert_money_withdrawal_with_expenses, document: :money_movement do
      conf.credit account: :sub_account_invested_capital, accountable: :sub_account
      conf.debit account: :investment_incomes, accountable: :membership
      conf.debit account: :amount_updated, accountable: :membership

      conf.credit account: :sub_account_capital, accountable: :sub_account
      conf.debit account: :amount_invested, accountable: :membership
    end

    conf.entry :money_withdrawal_without_changes, document: :money_movement do
      conf.debit account: :sub_account_invested_capital, accountable: :sub_account
      conf.credit account: :amount_updated, accountable: :membership

      conf.debit account: :sub_account_capital, accountable: :sub_account
      conf.credit account: :amount_invested, accountable: :membership
    end
  end
end
