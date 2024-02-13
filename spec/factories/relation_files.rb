FactoryBot.define do
  factory :relation_file do
    name { "MyString" }
    date { "2021-10-27" }
    document_type { :deed }
    file_data { TestData.get_data('application/pdf', 'pdf') }
    after(:build) do |relation_file|
      relation_file.relation ||= FactoryBot.create(:relation)
    end
  end
end
