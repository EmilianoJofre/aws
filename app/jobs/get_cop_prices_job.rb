class GetCopPricesJob < ApplicationJob
    queue_as :prices
  
    def perform
      GetCopPrices.for
    end
  end
  