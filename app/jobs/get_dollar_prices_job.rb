class GetDollarPricesJob < ApplicationJob
  queue_as :prices

  def perform
    GetDollarPrices.for
  end
end
