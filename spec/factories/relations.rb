FactoryBot.define do
  factory :relation do
    first_name { "relation" }
    last_name { "relation" }
    rut { "12345678-9" }
    sequence :email do |n|
      "name_#{n}@example.com"
    end
    password { '123456' }
    phone { "9866826" }
    user
  end
end
