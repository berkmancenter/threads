# frozen_string_literal: true
FactoryGirl.define do
  factory :message do
    room_id 1
    user_id 1
    content 'hello world'
  end
end
