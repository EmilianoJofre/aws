module CronUtils
  def self.get_job_cron(cron_name)
    Sidekiq.get_schedule[cron_name]['cron']
  end

  def self.next_ocurrence(cron_name)
    cron = get_job_cron(cron_name)
    Fugit::Cron.parse(cron).next_time
  end
end
