FactoryBot.define do
  factory :investment_asset do
    name { 'asset 1' }
    currency { 0 }
    sequence(:asset_id) { |n| "asset_#{n}" }
    asset_type { 1 }
    valid_asset { false }
    is_custom { false }
  end
end
