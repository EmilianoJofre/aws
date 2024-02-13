class GetEuroPrices < PowerTypes::Command.new
  EURO_URL = 'https://mindicador.cl/api/euro'

  def perform
    prices.each do |price|
      new_price = EuroPrice.find_or_initialize_by(date: price['fecha'].to_date)
      new_price.price = price['valor']
      new_price.save!
    end
  end

  private

  def prices
    @prices ||= HTTParty.get(EURO_URL)['serie']
  end
end
