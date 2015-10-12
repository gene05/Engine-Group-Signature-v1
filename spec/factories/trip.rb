FactoryGirl.define do
  factory :trip, :class => Signature::Trip do
    name "MyString"
     factory :trip_with_passengers do
       passengers { build_list(:passenger, 2) }
     end
  end
end
