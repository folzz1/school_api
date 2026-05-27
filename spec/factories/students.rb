FactoryBot.define do
  factory :student do
    first_name { "Ivan" }
    last_name { "Ivanov" }
    surname { "Ivanovich" }

    school
    school_class { association :school_class, school: school }
  end
end