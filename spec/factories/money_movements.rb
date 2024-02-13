FactoryBot.define do
  factory :money_movement do
    average_price { 1000 }
    quotas { 100 }
    date { '12-01-2020'.to_date }
    movement_type { 0 }
    sub_account
    membership
  end
end
