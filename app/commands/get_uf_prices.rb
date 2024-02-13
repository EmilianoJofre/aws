class GetUfPrices < PowerTypes::Command.new
  UF_URL = 'https://mindicador.cl/api/uf'

  def perform
    prices.each do |price|
      new_price = UfPrice.find_or_initialize_by(date: price['fecha'].to_date)
      new_price.price = price['valor']
      new_price.save!
    end
  end

  private

  def prices
    @prices ||= HTTParty.get(UF_URL)['serie']
  end
end
