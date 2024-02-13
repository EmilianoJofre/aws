class PriceChangeObserver < PowerTypes::Observer
  after_create :process_price_change

  def process_price_change
    if object.money_movement_id.nil?
      ProcessPriceChangeJob.perform_later(object)
    end
  end
end
