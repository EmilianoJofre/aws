FactoryBot.define do
  factory :account do
    name { 'relation 1' }
    rut { '123243131-1' }
    email { 'some@email.com' }
    bank
    relation
  end
end
