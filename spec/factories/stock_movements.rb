FactoryBot.define do
  factory :stock_movement do
    product { nil }
    user { nil }
    movement_type { 1 }
    quantity { "9.99" }
    unit_cost { "9.99" }
    reason { "MyText" }
    reference_document { "MyString" }
    movement_date { "2025-10-29 12:56:29" }
  end
end
