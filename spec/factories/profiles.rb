# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :profile do
    sequence(:first_name) { |n| "Karl#{n}" }
    sequence(:last_name) { |n| "Doe#{n}" }
    gender  "male"
    birth_date  15.years.ago
    school  "Schule am Griebnitzsee"
    street_name  "Rudolf-Breitscheid-Str. 52"
    zip_code  "14482"
    city  "Potsdam"
    state  "Babelsberg"
    country  "Deutschland"
    graduates_school_in "Bereits Abitur"
    discovery_of_site "Google"
    user
    trait :low_values do
      first_name "Andreas"
      last_name "Andresen"
      birth_date 13.years.ago    # low age, but higher date
      gender "male"
    end

    trait :high_values do
      first_name "Zoe"
      last_name "Z"
      birth_date 20.years.ago
      gender "female"
    end

    trait :long_name do
      first_name "Daniel-Amadeus Johannes Carl Philipp Maria Amadeus"
      last_name "von und zu Frankenstein, Junior"
    end
  end

  factory :adult_profile, parent: :profile do
    birth_date  18.years.ago
  end

end
