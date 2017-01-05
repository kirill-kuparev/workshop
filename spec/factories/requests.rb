# == Schema Information
#
# Table name: requests
#
#  id         :integer          not null, primary key
#  topics     :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :request do
    form_of_address :mrs
    first_name "Martina"
    last_name "Mustermann"
    phone_number "0123456789"
    address "Musterstraße 1 12345 Musterstadt"
    email "mustermann@example.de"
    topic_of_workshop "Hardware-Entwicklung mit einem CAD-System"
    number_of_participants 12
  end
end
