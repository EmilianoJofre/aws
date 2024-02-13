require 'rails_helper'

RSpec.describe UpdateRelationHistoryJob, type: :job do
  let(:relation) { create(:relation) }
  let(:time_window) { '1m' }

  describe 'perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(relation, time_window) }.to(
        have_enqueued_job(described_class)
      )
    end
  end

  describe 'perform_now' do
    before do
      allow(UpdateRelationHistoryTimeWindow).to receive(:for)
      described_class.perform_now(relation, time_window)
    end

    it 'calls UpdateRelationHistoryTimeWindow command' do
      expect(UpdateRelationHistoryTimeWindow).to(
        have_received(:for).once.with(relation: relation, time_window: time_window)
      )
    end
  end
end
