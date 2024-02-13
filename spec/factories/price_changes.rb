FactoryBot.define do
  factory :price_change do
    value { 300 }
    price_changed_at { '13-01-2020'.to_date }
    investment_asset
  end
end
