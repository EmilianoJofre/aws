class MoneyMovementObserver < PowerTypes::Observer
  after_create :process_money_movement

  def process_money_movement
    if object.deleted_by.nil?
      ProcessMoneyMovementJob.perform_later(object)
    else
      add_deleted_by_reference
    end
  end

  private

  def add_deleted_by_reference
    object.deleted_by.update!(deleted_by_id: object.id)
  end
end
