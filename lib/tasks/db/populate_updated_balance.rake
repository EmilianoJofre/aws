namespace :db do
  desc 'Populates updated balance into the Database'
  task populate_updated_balance: :environment do
    Membership.all.each do |membership|
      membership.update_balance
    end

    Account.all.each do |account|
      puts "problemas en Account ID#{account.id}" if (account.balance[:CLP] - account.updated_balance) < 1 
      puts "problemas en Account ID#{account.id}" if (account.balance[:CLP] - account.updated_balance) > 1 
    end
  end
end