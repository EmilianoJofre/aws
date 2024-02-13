require "rails_helper"

RSpec.describe ProcessPriceChangeJob, type: :job do
  let!(:price_change) { create(:price_change) }

  describe 'perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(price_change) }.to have_enqueued_job(described_class)
    end
  end

  describe "perform_now" do
    before do
      allow(Ledgerizer::ProcessPriceChange).to receive(:for)
    end

    it "calls Ledgerizer::ProcessPriceChange command" do
      described_class.perform_now(price_change)
      expect(Ledgerizer::ProcessPriceChange).to have_received(:for).once
    end
  end
end
