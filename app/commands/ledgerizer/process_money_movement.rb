class Ledgerizer::ProcessMoneyMovement < PowerTypes::Command.new(:money_movement)
  include MoneyMovementConcern

  def perform
    case @money_movement.movement_type
    when 'sale'
      Ledgerizer::ExecuteWithdrawal.for(
        user: @money_movement.user,
        money_movement: @money_movement
      )
      Ledgerizer::ProcessUserQuotaWithdrawal.for(
        user: @money_movement.user,
        money_movement: @money_movement
      )
    when 'purchase'
      Ledgerizer::ProcessUserMoneyInvestment.for(
        user: @money_movement.user,
        money_movement: @money_movement
      )
      Ledgerizer::ProcessUserQuotaInvestment.for(
        user: @money_movement.user,
        money_movement: @money_movement
      )
    end
  end
end
