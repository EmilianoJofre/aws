class UpdateChartsSimpleJob < ApplicationJob
  queue_as :default

  def perform
    Relation.all.find_each do |relation|
      # UpdateRelationChartsJob.perform_later(relation)
      UpdateRelationHistoryJob.perform_later(relation, 'mtd', 'v2')
      UpdateRelationHistoryJob.perform_later(relation, 'ytd', 'v2')
      UpdateRelationHistoryJob.perform_later(relation, '1m', 'v2')
      UpdateRelationHistoryJob.perform_later(relation, '3m', 'v2')
      UpdateRelationHistoryJob.perform_later(relation, '1y', 'v2')
    end    
  end
end
