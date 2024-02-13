describe GetDollarPrices do
  def perform
    described_class.for()
  end
  let(:url) { 'https://mindicador.cl/api/dolar' }
  let(:response) do
    {
      'serie' => [
        { 'fecha' => '2021-03-09T03:00:00.000Z', 'valor' => 740 },
        { 'fecha' => '2021-03-08T03:00:00.000Z', 'valor' => 733.11 },
        { 'fecha' => '2021-03-05T03:00:00.000Z', 'valor' => 729.15 },
        { 'fecha' => '2021-03-04T03:00:00.000Z', 'valor' => 731.3 }
      ]
    }
  end

  before do
    allow(HTTParty).to receive(:get).with(url).and_return(response)
  end

  context 'without existing prices' do
    it { expect { perform }.to change { DollarPrice.count }.by(4) }
  end

  context 'with existing prices' do
    let!(:price) { create(:dollar_price, date: '2021-03-09'.to_date) }

    it { expect { perform }.to change { DollarPrice.count }.by(3) }
  end
end
