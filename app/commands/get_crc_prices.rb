class GetCrcPrices < PowerTypes::Command.new
    CRC_URL = 'https://api.apilayer.com/fixer/latest?symbols=CLP&base=CRC'
    API_KEY = 'WjPb0mnJBMThKHGH8ddZfUBrJTO41oSY'
  
    def perform
      new_price = CrcPrice.find_or_initialize_by(date: price['date'].to_date)
      new_price.price = price['rates']['CLP']
      new_price.save!
    end
  
    private
  
    def price
      @price ||= HTTParty.get(
        CRC_URL,
        headers: { 'apiKey' => API_KEY }
      )
    end
  end