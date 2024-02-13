class Ledgerizer::ExecuteWithdrawal < PowerTypes::Command.new(
  :user,
  :money_movement
)
  include MoneyMovementConcern

  def perform
    before_withdrawal&.for(
      user: @user,
      price_change_document: price_change_document
    )
    withdrawal_type.for(
      user: @user,
      money_movement: @money_movement
    )
  end

  private

  def price_change
    @price_change ||= PriceChange.create(
      value: @money_movement.average_price,
      price_changed_at: @money_movement.date,
      investment_asset_id: investment_asset.id,
      money_movement_id: @money_movement.id
    )
  end

  def price_change_document
    @price_change_document ||= PriceChangeDocument.create(
      price_change: price_change,
      membership: membership
    )
  end

  def sale_price
    @sale_price ||= @money_movement.average_price.round(1)
  end

  def before_withdrawal
    updated_average_price = membership.updated_quota_average_price(
      @money_movement.date
    ).to_f.round(1)
    if sale_price > updated_average_price
      Ledgerizer::ProcessInvestmentIncomes
    elsif sale_price < updated_average_price
      Ledgerizer::ProcessInvestmentExpenses
    elsif sale_price == updated_average_price
      nil
    end
  end

  def withdrawal_type
    average_price = membership.quota_average_price(
      @money_movement.date
    ).to_f.round(1)
    if sale_price < average_price
      Ledgerizer::ProcessUserMoneyWithdrawalWithExpenses
    elsif sale_price > average_price
      Ledgerizer::ProcessUserMoneyWithdrawalWithIncomes
    elsif sale_price == average_price
      Ledgerizer::ProcessUserMoneyWithdrawalWithoutChanges
    end
  end
end
