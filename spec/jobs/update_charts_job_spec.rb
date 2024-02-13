require 'rails_helper'

RSpec.describe UpdateChartsJob, type: :job do
  let!(:relations_count) { 3 }
  let!(:relations) { create_list(:relation, relations_count) }

  describe 'perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to(
        have_enqueued_job(described_class)
      )
    end
  end

  describe 'perform_now' do
    before do
      allow(UpdateRelationChartsJob).to receive(:perform_later)
      described_class.perform_now
    end

    it 'calls UpdateRelationChartsJob with correct params' do
      relations.each do |relation|
        expect(UpdateRelationChartsJob).to have_received(:perform_later).with(relation)
      end
    end
  end
end
