FactoryGirl.define do
  factory :ingredient do
    sequence(:index)
    quantity '1/2'
    measurement 'cup'
    description 'milk'
  end
end
