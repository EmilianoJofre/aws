class UpdateChartsComplexJob < ApplicationJob
  queue_as :default

  def perform
    Relation.all.find_each do |relation|
      UpdateRelationChartsJob.perform_later(relation)
      UpdateRelationHistoryJob.perform_later(relation, 'origin', 'v2')
      UpdateRelationHistoryJob.perform_later(relation, '5y', 'v2')
      UpdateRelationHistoryJob.perform_later(relation, 'complete', 'v2')
    end
  end
end
