# frozen_string_literal: true
class Instance < ApplicationRecord
  before_create :generate_token

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :rooms, dependent: :destroy
  has_many :moderatorships, dependent: :destroy
  has_many :moderators, through: :moderatorships, source: :user

  validates :title, presence: true, length: { maximum: 1000 }

  def rooms_sorted_by_last_message
    rooms.includes(:messages).order('messages.created_at DESC NULLS LAST')
  end

  def self.all_for_user(user)
    return all.order(:title) if user.role? Role.admin

    Instance.where(private: false).or(Instance.where(owner_id: user.id)).order(:title)
  end

  private

  def generate_token
    self.access_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Instance.exists?(access_token: random_token)
    end
  end
end
