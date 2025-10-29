FactoryBot.define do
  factory :supplier do
    name { "MyString" }
    cnpj { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    address { "MyText" }
    contact_person { "MyString" }
    active { false }
    deleted_at { "2025-10-29 12:55:52" }
  end
end
