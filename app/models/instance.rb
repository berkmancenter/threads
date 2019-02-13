# frozen_string_literal: true
class Instance < ApplicationRecord
  belongs_to :owner, class_name: User, foreign_key: :owner_id
  has_many :rooms

  validates :title, presence: true, length: { maximum: 1000 }
end
