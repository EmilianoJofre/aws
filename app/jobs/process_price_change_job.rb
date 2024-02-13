class ProcessPriceChangeJob < ApplicationJob
  queue_as :default

  def perform(price_change)
    Ledgerizer::ProcessPriceChange.for(price_change: price_change)
  end
end
