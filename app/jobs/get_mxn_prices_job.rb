class GetMxnPricesJob < ApplicationJob
    queue_as :prices
  
    def perform
      GetMxnPrices.for
    end
  end
  