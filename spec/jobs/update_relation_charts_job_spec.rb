require 'rails_helper'

RSpec.describe UpdateRelationChartsJob, type: :job do
  let(:relation) { create(:relation) }
  let(:time_windows) { RelationHistory.time_windows.keys }

  describe 'perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(relation) }.to(
        have_enqueued_job(described_class)
      )
    end
  end

  describe 'perform_now' do
    before do
      allow(UpdateRelationHistoryJob).to receive(:perform_later)
      described_class.perform_now(relation)
    end

    it 'calls UpdateRelationHistoryJob with correct params' do
      time_windows.each do |time_window|
        expect(UpdateRelationHistoryJob).to have_received(:perform_later)
          .with(relation, time_window)
      end
    end
  end
end
