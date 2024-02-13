FactoryBot.define do
  factory :sub_account do
    currency { 0 }
    sub_account_id { 'XFSPW' }
    account
  end
end
