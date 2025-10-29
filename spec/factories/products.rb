FactoryBot.define do
  factory :product do
    sku { "MyString" }
    name { "MyString" }
    description { "MyText" }
    category { nil }
    supplier { nil }
    unit_of_measure { 1 }
    cost_price { "9.99" }
    selling_price { "9.99" }
    current_stock { "9.99" }
    minimum_stock { "9.99" }
    maximum_stock { "9.99" }
    active { false }
    deleted_at { "2025-10-29 12:56:06" }
  end
end
