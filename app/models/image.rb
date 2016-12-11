# frozen_string_literal: true
# == Schema Information
#
# Table name: images
#
#  id           :integer          not null, primary key
#  file         :string           not null
#  name         :string           not null
#  size         :integer          not null
#  content_type :string           not null
#  digest       :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Image < ApplicationRecord
  validates :file, presence: true
  validates :name, presence: true
  validates :size, presence: true
  validates :content_type, presence: true
  validates :digest, presence: true

  mount_uploader :file, ImageUploader

  before_validation :set_file_meta_data

  private

  def set_file_meta_data
    if file.present? && file_changed?
      self.name ||= file.filename
      self.digest ||= file.sha256_digest
      self.content_type ||= file.content_type
      self.size ||= file.size
    end
  end
end
