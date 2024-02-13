class RelationCurrentDistribution < PowerTypes::Command.new(:relation)
  def perform
    dollar_price = DollarPrice.step_business_day
    euro_price = EuroPrice.step_business_day
    uf_price = UfPrice.step_business_day
    mxn_price = MxnPrice.step_business_day
    cop_price = CopPrice.step_business_day
    crc_price = CrcPrice.step_business_day
    distribution = Hash.new(0)
    @relation.memberships.active.each do |membership|
      balance = balance(membership, dollar_price)
      distribution['total'] += balance
      distribution[membership.investment_asset.asset_type] += balance
    end
    distribution
  end

  private

  def balance(membership, dollar_price)
    balance = membership.amount_updated_balance(Date.current) || 0

    return balance if membership.currency == 'CLP'

    balance * dollar_price
  end
end
