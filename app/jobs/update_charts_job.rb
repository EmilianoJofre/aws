class UpdateChartsJob < ApplicationJob
  queue_as :default

  def perform
    Relation.all.find_each do |relation|
      UpdateRelationChartsJob.perform_later(relation)
    end
  end
end
