require "rails_helper"

RSpec.describe ProcessMoneyMovementJob, type: :job do
  let!(:movement) { create(:money_movement) }

  describe 'perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(movement) }.to have_enqueued_job(described_class)
    end
  end

  describe "perform_now" do
    before do
      allow(Ledgerizer::ProcessMoneyMovement).to receive(:for)
    end

    it "calls Ledgerizer::ProcessMoneyMovement command" do
      described_class.perform_now(movement)
      expect(Ledgerizer::ProcessMoneyMovement).to have_received(:for).once
    end
  end
end
