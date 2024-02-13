class ProcessMoneyMovementJob < ApplicationJob
  queue_as :default

  def perform(movement)
    begin
      Ledgerizer::ProcessMoneyMovement.for(money_movement: movement)
    rescue => exception
      puts "ERROR:" + exception.inspect.to_s
    end
  end
end
