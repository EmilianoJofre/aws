class Ledgerizer::ProcessPriceChange < PowerTypes::Command.new(:price_change)
  def perform
    investment_asset.memberships.each do |membership|
      if membership&.quotas_balance&.positive?
        document = PriceChangeDocument.create(
          price_change: @price_change,
          membership: membership
        )
        command(membership)&.for(
          user: membership.user,
          price_change_document: document
        )
      end
      membership.update_balance
    end
  end

  private

  def investment_asset
    @investment_asset ||= @price_change.investment_asset
  end

  def command(membership)
    updated_average_price = membership.updated_quota_average_price
    new_price = @price_change.value
    if new_price > updated_average_price
      Ledgerizer::ProcessInvestmentIncomes
    elsif new_price < updated_average_price
      Ledgerizer::ProcessInvestmentExpenses
    elsif new_price == updated_average_price
      nil
    end
  end
end
