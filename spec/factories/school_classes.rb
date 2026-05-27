FactoryBot.define do
  factory :school_class do
    association :school
    number { 10 }
    letter { "A" }
  end
end