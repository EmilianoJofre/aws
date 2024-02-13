require 'rails_helper'

RSpec.describe RelationHistory, type: :model do
  it 'has a valid factory' do
    expect(build(:relation_history)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:relation) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :time_window }
  end
end
