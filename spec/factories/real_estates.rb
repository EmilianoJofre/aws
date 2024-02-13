FactoryBot.define do
  factory :real_estate do
    investment_asset { nil }
    lat { "MyString" }
    lon { "MyString" }
    location_sql { "MyString" }
    address { "MyString" }
    asset_destination { "MyString" }
    contributions { 1.5 }
    fiscal_appraisal { 1.5 }
    area { 1.5 }
    builded_area { 1.5 }
    year { "" }
  end
end
