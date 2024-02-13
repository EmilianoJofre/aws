module WalletConcern
  extend ActiveSupport::Concern

  def currency_total_wallet(currency, date = Time.current)
    accounts.find_by(name: account_name_criteria_for_currency_total, currency: currency)
      &.balance_at(date)
      &.amount
  end

  def total_wallet(date = Time.current)
    {
      CLP: currency_total_sum('CLP', date),
      USD: currency_total_sum('USD', date),
      EUR: currency_total_sum('EUR', date),
      UF: currency_total_sum('UF', date),
      MXN: currency_total_sum('MXN', date),
      COP: currency_total_sum('COP', date),
      CRC: currency_total_sum('CRC', date),
    }
  end

  def currency_total_sum(currency, date)
    dollar = DollarPrice.step_business_day
    euro = EuroPrice.step_business_day
    uf = UfPrice.step_business_day
    mxn = MxnPrice.step_business_day
    cop = CopPrice.step_business_day
    crc = CrcPrice.step_business_day
    case currency
    when 'CLP'
      currency_total_wallet('CLP', date).to_f + currency_total_wallet('USD', date).to_f * dollar
    when 'USD'
      currency_total_wallet('USD', date).to_f + currency_total_wallet('CLP', date).to_f / dollar
    when 'EUR'
      currency_total_wallet('EUR', date).to_f + currency_total_wallet('CLP', date).to_f / dollar
    when 'UF'
      currency_total_wallet('UF', date).to_f + currency_total_wallet('CLP', date).to_f / dollar
    when 'MXN'
      currency_total_wallet('MXN', date).to_f + currency_total_wallet('CLP', date).to_f / dollar
    when 'COP'
      currency_total_wallet('COP', date).to_f + currency_total_wallet('CLP', date).to_f / dollar
    when 'CRC'
      currency_total_wallet('CRC', date).to_f + currency_total_wallet('CLP', date).to_f / dollar
    end
  end
end
