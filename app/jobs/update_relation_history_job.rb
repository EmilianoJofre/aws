class UpdateRelationHistoryJob < ApplicationJob
  queue_as :default

  def perform(relation, time_window, version = 'v1')
    UpdateRelationHistoryTimeWindow.for(relation: relation, time_window: time_window, version: version)
  end
end
