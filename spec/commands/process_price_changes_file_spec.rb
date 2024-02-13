describe ProcessPriceChangesFile do
  def perform
    described_class.for(file: file)
  end

  let(:xlsx) { double }
  let(:file) { double }
  let(:tempfile) { double }
  let(:path) { double }
  let(:asset_1) { create(:investment_asset, asset_id: 'BTC') }
  let(:asset_2) { create(:investment_asset, asset_id: 'ETH') }
  let(:nil_metrics) do
    {
      'mtd' => nil, 'recovery_level' => nil, 'qtd' => nil,
      'ytd' => nil, 'y1' => nil, 'y3' => nil, 'y5' => nil
    }
  end
  let(:asset_1_new_metrics) do
    {
      'mtd' => 0.1, 'recovery_level' => 0.1, 'qtd' => 0.1,
      'ytd' => 0.1, 'y1' => 0.1, 'y3' => 0.1, 'y5' => 0.1
    }
  end
  let(:asset_2_new_metrics) do
    {
      'mtd' => -0.1, 'recovery_level' => -0.1, 'qtd' => -0.1,
      'ytd' => -0.1, 'y1' => -0.1, 'y3' => -0.1, 'y5' => -0.1
    }
  end
  let(:attributes) { ['mtd', 'recovery_level', 'qtd', 'ytd', 'y1', 'y3', 'y5'] }

  before do
    allow(file).to receive(:tempfile).and_return(tempfile)
    allow(tempfile).to receive(:path).and_return(path)
    allow(Roo::Spreadsheet).to receive(:open).with(path).and_return(xlsx)
    allow(InvestmentAsset).to receive(:find_by).with(asset_id: 'BTC').and_return(asset_1)
    allow(InvestmentAsset).to receive(:find_by).with(asset_id: 'ETH').and_return(asset_2)
  end

  context 'with valid file' do
    before do
      allow(xlsx).to receive(:parse).and_return(
        [
          {
            'id' => 'id', 'price' => 'price', 'mtd' => 'mtd', 'recovery level' => 'recovery level',
            'qtd' => 'qtd', 'ytd' => 'ytd', '1y' => '1y', '3y' => '3y', '5y' => '5y'
          },
          {
            'id' => 'BTC', 'price' => 1000, 'mtd' => 0.1, 'recovery level' => 0.1,
            'qtd' => 0.1, 'ytd' => 0.1, '1y' => 0.1, '3y' => 0.1, '5y' => 0.1
          },
          {
            'id' => 'ETH', 'price' => 100, 'mtd' => -0.1, 'recovery level' => -0.1,
            'qtd' => -0.1, 'ytd' => -0.1, '1y' => -0.1, '3y' => -0.1, '5y' => -0.1
          }
        ]
      )
    end

    context 'with one new price' do
      let(:last_price_1) { create(:price_change, value: 1000) }

      before do
        allow(asset_1).to receive(:last_price_change).and_return(last_price_1)
        allow(asset_2).to receive(:last_price_change).and_return(nil)
      end

      it { expect { perform }.to change { PriceChange.count }.by(1) }

      it 'updates asset 1' do
        expect { perform }
          .to change { asset_1.attributes.slice(*attributes) }
          .from(nil_metrics)
          .to(asset_1_new_metrics)
      end

      it 'updates asset 2' do
        expect { perform }
          .to change { asset_2.attributes.slice(*attributes) }
          .from(nil_metrics)
          .to(asset_2_new_metrics)
      end
    end

    context 'with all new prices' do
      let(:last_price_1) { create(:price_change, value: 900) }

      before do
        allow(asset_1).to receive(:last_price_change).and_return(last_price_1)
        allow(asset_2).to receive(:last_price_change).and_return(nil)
      end

      it { expect { perform }.to change { PriceChange.count }.by(2) }

      it 'updates asset 1' do
        expect { perform }
          .to change { asset_1.attributes.slice(*attributes) }
          .from(nil_metrics)
          .to(asset_1_new_metrics)
      end

      it 'updates asset 2' do
        expect { perform }
          .to change { asset_2.attributes.slice(*attributes) }
          .from(nil_metrics)
          .to(asset_2_new_metrics)
      end
    end
  end

  context 'with invalid file' do
    before do
      allow(xlsx).to receive(:parse).and_return(
        [
          { 'ids' => 'id', 'prices' => 'price' },
          { 'id' => 'BTC', 'prices' => 1000 },
          { 'ids' => 'ETH', 'price' => 100 }
        ]
      )
    end

    it { expect { perform }.to change { PriceChange.count }.by(0) }

    it 'do not updates asset 1' do
      expect { perform }.not_to(change { asset_1.attributes.slice(*attributes) })
    end

    it 'do not updates asset 2' do
      expect { perform }.not_to(change { asset_2.attributes.slice(*attributes) })
    end
  end
end
