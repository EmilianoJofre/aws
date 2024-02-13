RSpec.describe CronUtils do
  let(:cron) { '0 */6 * * *' }
  let(:cron_job) { 'update_charts' }
  let(:sidekiq_schedule) do
    { cron_job => {
      'cron' => cron, 'class' => 'UpdateChartsJob', 'queue' => 'default'
    } }
  end
  let(:now) { Time.zone.local(2021, 1, 1) }
  let(:next_ocurrence_seconds) { Time.zone.local(2021, 1, 1, 6).to_i }

  describe '.get_job_cron' do
    before do
      allow(Sidekiq).to receive(:get_schedule).and_return(sidekiq_schedule)
    end

    it 'return correct cron' do
      expect(described_class.get_job_cron(cron_job)).to eq(cron)
    end
  end

  describe '.next_ocurrence' do
    before do
      Timecop.freeze(now)
      allow(Sidekiq).to receive(:get_schedule).and_return(sidekiq_schedule)
    end

    it 'return correct next ocurrence' do
      expect(described_class.next_ocurrence(cron_job).seconds).to eq(next_ocurrence_seconds)
    end
  end
end
