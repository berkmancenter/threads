# frozen_string_literal: true
class Moderatorship < ApplicationRecord
  belongs_to :user
  belongs_to :instance
end
