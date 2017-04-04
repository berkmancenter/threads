# frozen_string_literal: true
# == Schema Information
#
# Table name: room_users
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  room_id              :integer          not null
#  last_read_message_id :integer
#  unread_message_count :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :room_user do
  end
end
