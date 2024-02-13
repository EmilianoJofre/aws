class FixLedgerizerJob < ApplicationJob
  queue_as :fixes

  def perform(*args)
    fix_money_movements
    fix_price_changes
  end

  def fix_price_changes
    sql = "select pc.* from price_changes pc left join price_change_documents pcd on pc.id = pcd.price_change_id where pcd.id is null order by pc.id asc"
    pending_price_changes = PriceChange.find_by_sql sql

    pending_price_changes.each do |price_change|
      ProcessPriceChangeJob.perform_now price_change
    end 
  end

  def fix_money_movements
    sql = "select mm.* from money_movements mm where mm.membership_id in (select m.id from memberships m left join ledgerizer_accounts la on m.id = la.accountable_id where la.id is null order by m.id desc);"
    pending_money_movements = MoneyMovement.find_by_sql sql

    pending_money_movements.each do |money_movement|
      ProcessMoneyMovementJob.perform_now money_movement
    end 
  end
end
