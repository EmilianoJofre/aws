class GetEuroPricesJob < ApplicationJob
  queue_as :prices

  def perform
    GetEuroPrices.for
  end
end
