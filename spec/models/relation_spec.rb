require 'rails_helper'

RSpec.describe Relation, type: :model do
  it 'has a valid factory' do
    expect(build(:relation)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:relation_accounts) }
    it { is_expected.to have_many(:sub_accounts).through(:relation_accounts) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
    it { is_expected.to validate_presence_of :rut }
  end
end
