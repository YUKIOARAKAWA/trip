# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
#  factory :admin, class: Plan do
    email "test@example.com"
    password "password"
    sign_in_count 1
    name "テストユーザ"
  end
end
