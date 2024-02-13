FactoryBot.define do
  factory :wallet_withdrawal do
    sub_account
    date { "2021-06-08" }
    amount { 1.5 }
  end
end
