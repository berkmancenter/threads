# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:owner).class_name(User).with_foreign_key(:owner_id) }
    it { is_expected.to have_many(:messages) }
    it { is_expected.to have_many(:users).through(:messages) }
  end
end
