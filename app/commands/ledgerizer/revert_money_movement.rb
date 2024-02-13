class Ledgerizer::RevertMoneyMovement < PowerTypes::Command.new(:money_movement)
  def perform
    return if @money_movement.deleted_by_id

    case @money_movement.movement_type
    when 'purchase'
      revert_purchase
    when 'sale'
      revert_sale
    end
  end

  private

  def revert_purchase
    Ledgerizer::ProcessUserMoneyWithdrawalWithoutChanges.for(
      user: new_money_movement.user,
      money_movement: new_money_movement
    )
    Ledgerizer::ProcessUserQuotaWithdrawal.for(
      user: new_money_movement.user,
      money_movement: new_money_movement
    )
    true
  end

  def revert_sale
    Ledgerizer::ExecuteRevertWithdrawal.for(
      user: new_money_movement.user,
      money_movement: new_money_movement
    )
    Ledgerizer::ProcessUserQuotaInvestment.for(
      user: new_money_movement.user,
      money_movement: new_money_movement
    )
    true
  end

  def new_money_movement
    @new_money_movement ||= @money_movement.membership.money_movements.create!(
      new_movement_attributes
    )
  end

  def new_movement_attributes
    @money_movement.attributes.slice(
      'quotas', 'sub_account_id', 'membership_id', 'movement_type', 'average_price'
    ).merge(deleted_by_id: @money_movement.id, date: new_date)
  end

  def new_date
    @new_date ||= @money_movement.date + 1.minute
  end
end
