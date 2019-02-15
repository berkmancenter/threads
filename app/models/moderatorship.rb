class Moderatorship < ApplicationRecord
  belongs_to :user
  belongs_to :instance
end
