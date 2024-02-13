class GetUfPricesJob < ApplicationJob
  queue_as :prices

  def perform
    GetUfPrices.for
  end
end
