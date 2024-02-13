require "rails_helper"

RSpec.describe GetDollarPricesJob, type: :job do
  describe 'perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe "perform_now" do
    before do
      allow(GetDollarPrices).to receive(:for)
    end

    it "calls GetDollarPrice command" do
      described_class.perform_now
      expect(GetDollarPrices).to have_received(:for).once
    end
  end
end
