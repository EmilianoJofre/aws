require 'rails_helper'

describe PriceChangeObserver do
  def trigger(_type, _event)
    described_class.trigger(_type, _event, price_change)
  end

  let(:price_change) { create(:price_change) }

  context "when a price change is created" do
    before do
      allow(ProcessPriceChangeJob).to receive(:perform_later)
    end

    it 'calls process price change job' do
      trigger(:after, :create)
      expect(ProcessPriceChangeJob).to have_received(:perform_later).once.with(
        price_change
      )
    end
  end
end
