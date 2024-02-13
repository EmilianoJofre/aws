class GetCrcPricesJob < ApplicationJob
    queue_as :prices
  
    def perform
      GetCrcPrices.for
    end
  end
  