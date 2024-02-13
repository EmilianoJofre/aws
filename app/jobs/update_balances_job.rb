class UpdateBalancesJob < ApplicationJob
  queue_as :default

  def perform
    Membership.all.each do |membership|
      membership.update_balance
    end
  end
end