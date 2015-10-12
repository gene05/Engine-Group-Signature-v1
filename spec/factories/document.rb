FactoryGirl.define do
    factory :document, :class => Signature::Document do
      title "MyString"
      content "StringContent {{@NAME@}}"
    end
end
