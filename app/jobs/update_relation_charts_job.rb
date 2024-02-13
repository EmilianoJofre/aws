class UpdateRelationChartsJob < ApplicationJob
  queue_as :default

  def perform(relation)
    time_windows.each do |window|
      UpdateRelationHistoryJob.perform_later(relation, window)
    end
  end

  def time_windows
    RelationHistory.time_windows.keys
  end
end
