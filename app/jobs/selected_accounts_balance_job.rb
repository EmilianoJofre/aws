class SelectedAccountsBalanceJob < ApplicationJob
  queue_as :default

  def perform(rel, ids, window, summary = nil)
    return if rel.blank?

    relation_history = rel.relation_histories.find_by(time_window: window)

    return if relation_history.nil?

    @ids = ids
    @summary = summary

    relation_history.balances_values = calculate_accounts_balance(
      relation_history.balances_values,
      method(:sum_balances)
    )
    # relation_history.wallet_values = calculate_accounts_balance(
    #   relation_history.wallet_values,
    #   method(:sum_wallets)
    # )

    relation_history
  end

  private

  def calculate_accounts_balance(values, function)
    dates = JSON.parse(values)
    dates.each do |date, balances|
      dates[date]['selected'] = function.call(balances)
    end
    dates.to_json
  end

  def sum_balances(balances)
    selected_accounts_balance = { balance: { CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0 } }
    # selected_accounts_balance = { balance: { CLP: 0 } }
    balances.each do |key, balance|
      if @summary
        selected_accounts_balance[:balance][:investment] ||= {}
        selected_accounts_balance[:balance][:investment][:CLP] ||= 0
        selected_accounts_balance[:balance][:investment][:USD] ||= 0
        selected_accounts_balance[:balance][:investment][:EUR] ||= 0
        selected_accounts_balance[:balance][:investment][:UF] ||= 0
        selected_accounts_balance[:balance][:investment][:MXN] ||= 0
        selected_accounts_balance[:balance][:investment][:COP] ||= 0
        selected_accounts_balance[:balance][:investment][:CRC] ||= 0
        selected_accounts_balance[:balance][:pension_fund] ||= {}
        selected_accounts_balance[:balance][:pension_fund][:CLP] ||= 0
        selected_accounts_balance[:balance][:pension_fund][:USD] ||= 0
        selected_accounts_balance[:balance][:pension_fund][:EUR] ||= 0
        selected_accounts_balance[:balance][:pension_fund][:UF] ||= 0
        selected_accounts_balance[:balance][:pension_fund][:MXN] ||= 0
        selected_accounts_balance[:balance][:pension_fund][:COP] ||= 0
        selected_accounts_balance[:balance][:pension_fund][:CRC] ||= 0
        selected_accounts_balance[:balance][:real_estate] ||= {}
        selected_accounts_balance[:balance][:real_estate][:CLP] ||= 0
        selected_accounts_balance[:balance][:real_estate][:USD] ||= 0
        selected_accounts_balance[:balance][:real_estate][:EUR] ||= 0
        selected_accounts_balance[:balance][:real_estate][:UF] ||= 0
        selected_accounts_balance[:balance][:real_estate][:MXN] ||= 0
        selected_accounts_balance[:balance][:real_estate][:COP] ||= 0
        selected_accounts_balance[:balance][:real_estate][:CRC] ||= 0
        selected_accounts_balance[:balance][:liability] ||= {}
        selected_accounts_balance[:balance][:liability][:CLP] ||= 0
        selected_accounts_balance[:balance][:liability][:USD] ||= 0
        selected_accounts_balance[:balance][:liability][:EUR] ||= 0
        selected_accounts_balance[:balance][:liability][:UF] ||= 0
        selected_accounts_balance[:balance][:liability][:MXN] ||= 0
        selected_accounts_balance[:balance][:liability][:COP] ||= 0
        selected_accounts_balance[:balance][:liability][:CRC] ||= 0
        selected_accounts_balance[:balance][:others] ||= {}
        selected_accounts_balance[:balance][:others][:CLP] ||= 0
        selected_accounts_balance[:balance][:others][:USD] ||= 0
        selected_accounts_balance[:balance][:others][:EUR] ||= 0
        selected_accounts_balance[:balance][:others][:UF] ||= 0
        selected_accounts_balance[:balance][:others][:MXN] ||= 0
        selected_accounts_balance[:balance][:others][:COP] ||= 0
        selected_accounts_balance[:balance][:others][:CRC] ||= 0
        next if key == 'all'
        if Account.find_by(id: key).account_type == 'investment'
          selected_accounts_balance[:balance][:investment][:CLP] += balance['balance']['CLP']
          selected_accounts_balance[:balance][:investment][:USD] += balance['balance']['USD']
          selected_accounts_balance[:balance][:investment][:EUR] += balance['balance']['EUR']
          selected_accounts_balance[:balance][:investment][:UF] += balance['balance']['UF']
          selected_accounts_balance[:balance][:investment][:MXN] += balance['balance']['MXN']
          selected_accounts_balance[:balance][:investment][:COP] += balance['balance']['COP']
          selected_accounts_balance[:balance][:investment][:CRC] += balance['balance']['CRC']
          selected_accounts_balance[:balance][:CLP] += balance['balance']['CLP']
          selected_accounts_balance[:balance][:USD] += balance['balance']['USD']
          selected_accounts_balance[:balance][:EUR] += balance['balance']['EUR']
          selected_accounts_balance[:balance][:UF] += balance['balance']['UF']
          selected_accounts_balance[:balance][:MXN] += balance['balance']['MXN']
          selected_accounts_balance[:balance][:COP] += balance['balance']['COP']
          selected_accounts_balance[:balance][:CRC] += balance['balance']['CRC']
        elsif Account.find_by(id: key).account_type == 'pension_fund'
          selected_accounts_balance[:balance][:pension_fund][:CLP] += balance['balance']['CLP']
          selected_accounts_balance[:balance][:pension_fund][:USD] += balance['balance']['USD']
          selected_accounts_balance[:balance][:pension_fund][:EUR] += balance['balance']['EUR']
          selected_accounts_balance[:balance][:pension_fund][:UF] += balance['balance']['UF']
          selected_accounts_balance[:balance][:pension_fund][:MXN] += balance['balance']['MXN']
          selected_accounts_balance[:balance][:pension_fund][:COP] += balance['balance']['COP']
          selected_accounts_balance[:balance][:pension_fund][:CRC] += balance['balance']['CRC']
          selected_accounts_balance[:balance][:CLP] += balance['balance']['CLP']
          selected_accounts_balance[:balance][:USD] += balance['balance']['USD']
          selected_accounts_balance[:balance][:EUR] += balance['balance']['EUR']
          selected_accounts_balance[:balance][:UF] += balance['balance']['UF']
          selected_accounts_balance[:balance][:MXN] += balance['balance']['MXN']
          selected_accounts_balance[:balance][:COP] += balance['balance']['COP']
          selected_accounts_balance[:balance][:CRC] += balance['balance']['CRC']
        elsif Account.find_by(id: key).account_type == 'real_estate'
          selected_accounts_balance[:balance][:real_estate][:CLP] += balance['balance']['CLP']
          selected_accounts_balance[:balance][:real_estate][:USD] += balance['balance']['USD']
          selected_accounts_balance[:balance][:real_estate][:EUR] += balance['balance']['EUR']
          selected_accounts_balance[:balance][:real_estate][:UF] += balance['balance']['UF']
          selected_accounts_balance[:balance][:real_estate][:MXN] += balance['balance']['MXN']
          selected_accounts_balance[:balance][:real_estate][:COP] += balance['balance']['COP']
          selected_accounts_balance[:balance][:real_estate][:CRC] += balance['balance']['CRC']
          selected_accounts_balance[:balance][:CLP] += balance['balance']['CLP']
          selected_accounts_balance[:balance][:USD] += balance['balance']['USD']
          selected_accounts_balance[:balance][:EUR] += balance['balance']['EUR']
          selected_accounts_balance[:balance][:UF] += balance['balance']['UF']
          selected_accounts_balance[:balance][:MXN] += balance['balance']['MXN']
          selected_accounts_balance[:balance][:COP] += balance['balance']['COP']
          selected_accounts_balance[:balance][:CRC] += balance['balance']['CRC']
        elsif Account.find_by(id: key).account_type == 'liability'
          selected_accounts_balance[:balance][:liability][:CLP] -= balance['balance']['CLP']
          selected_accounts_balance[:balance][:liability][:USD] -= balance['balance']['USD']
          selected_accounts_balance[:balance][:liability][:EUR] -= balance['balance']['EUR']
          selected_accounts_balance[:balance][:liability][:UF] -= balance['balance']['UF']
          selected_accounts_balance[:balance][:liability][:MXN] -= balance['balance']['MXN']
          selected_accounts_balance[:balance][:liability][:COP] -= balance['balance']['COP']
          selected_accounts_balance[:balance][:liability][:CRC] -= balance['balance']['CRC']
        elsif Account.find_by(id: key).account_type == 'others'
          selected_accounts_balance[:balance][:others][:CLP] += balance['balance']['CLP']
          selected_accounts_balance[:balance][:others][:USD] += balance['balance']['USD']
          selected_accounts_balance[:balance][:others][:EUR] += balance['balance']['EUR']
          selected_accounts_balance[:balance][:others][:UF] += balance['balance']['UF']
          selected_accounts_balance[:balance][:others][:MXN] += balance['balance']['MXN']
          selected_accounts_balance[:balance][:others][:COP] += balance['balance']['COP']
          selected_accounts_balance[:balance][:others][:CRC] += balance['balance']['CRC']
          selected_accounts_balance[:balance][:CLP] -= balance['balance']['CLP']
          selected_accounts_balance[:balance][:USD] -= balance['balance']['USD']
          selected_accounts_balance[:balance][:EUR] -= balance['balance']['EUR']
          selected_accounts_balance[:balance][:UF] -= balance['balance']['UF']
          selected_accounts_balance[:balance][:MXN] -= balance['balance']['MXN']
          selected_accounts_balance[:balance][:COP] -= balance['balance']['COP']
          selected_accounts_balance[:balance][:CRC] -= balance['balance']['CRC']
        end
      elsif key.in? @ids
        selected_accounts_balance[:balance][:CLP] += balance['balance']['CLP']
        selected_accounts_balance[:balance][:USD] += balance['balance']['USD']
        selected_accounts_balance[:balance][:EUR] += balance['balance']['EUR']
        selected_accounts_balance[:balance][:UF] += balance['balance']['UF']
        selected_accounts_balance[:balance][:MXN] += balance['balance']['MXN']
        selected_accounts_balance[:balance][:COP] += balance['balance']['COP']
        selected_accounts_balance[:balance][:CRC] += balance['balance']['CRC']
      end
      selected_accounts_balance[:invested_amount] = {}
      selected_accounts_balance[:invested_amount][:CLP] = balance['balance']['CLP']
      selected_accounts_balance[:invested_amount][:USD] = balance['balance']['USD']
      selected_accounts_balance[:invested_amount][:EUR] = balance['balance']['EUR']
      selected_accounts_balance[:invested_amount][:UF] = balance['balance']['UF']
      selected_accounts_balance[:invested_amount][:MXN] = balance['balance']['MXN']
      selected_accounts_balance[:invested_amount][:COP] = balance['balance']['COP']
      selected_accounts_balance[:invested_amount][:CRC] = balance['balance']['CRC']
    end

    selected_accounts_balance
  end


  def sum_wallets(wallets)
    selected_accounts_wallet = { CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    wallets.each do |key, wallet|
      if key.in? @ids
        selected_accounts_wallet[:CLP] += wallet['CLP'] if wallet.key? 'CLP'
        # selected_accounts_wallet[:USD] += wallet['USD'] if wallet.key? 'USD'
        # selected_accounts_wallet[:EUR] += wallet['EUR'] if wallet.key? 'EUR'
        # selected_accounts_wallet[:UF] += wallet['UF'] if wallet.key? 'UF'
        # selected_accounts_wallet[:MXN] += wallet['MXN'] if wallet.key? 'MXN'
        # selected_accounts_wallet[:COP] += wallet['COP'] if wallet.key? 'COP'
        # selected_accounts_wallet[:CRC] += wallet['CRC'] if wallet.key? 'CRC'
      end
    end
    selected_accounts_wallet
  end

end
