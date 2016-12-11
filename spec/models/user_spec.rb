# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:avatar).class_name(Image).with_foreign_key(:avatar_id) }
    it { is_expected.to have_many(:messages) }
    it { is_expected.to have_many(:rooms).through(:messages) }
  end

  describe 'validations' do
  end
end
