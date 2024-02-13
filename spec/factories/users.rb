FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "name_#{n}@example.com"
    end
    password { '123456' }
    first_name { 'SuperUser' }
    last_name { 'LastName' }
    phone_number { '569000000' }
    institution { 'Platanus' }
  end
end
