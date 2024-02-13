FactoryBot.define do
  factory :relation_history do
    relation
    time_window { 1 }
    wallet_values { {}.to_json }
    balances_values { {}.to_json }
  end
end
