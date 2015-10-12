FactoryGirl.define do
    factory :passenger, :class => Signature::Passenger do
      name "MyString"
      email "passenger@email.com"
    end
end
