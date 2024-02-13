require 'rails_helper'

RSpec.describe MoneyMovement, type: :model do
  it 'has a valid factory' do
    expect(build(:money_movement)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:sub_account) }
    it { is_expected.to belong_to(:membership) }
    it { is_expected.to belong_to(:deleted_by).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :average_price }
    it { is_expected.to validate_presence_of :quotas }
    it { is_expected.to validate_presence_of :date }
  end

  describe 'callbacks' do
    context 'when sale movement is created' do
      before do
        allow_any_instance_of(Membership).to receive(:quotas_balance).and_return(100)
      end

      context 'when doesnt have enough quota on create' do
        it 'is valid with deleted_by_id not nil' do
          movement = build(:money_movement, movement_type: 'sale', quotas: 101, deleted_by_id: 1)
          expect(movement).to be_valid
        end

        it 'is invalid' do
          movement = build(:money_movement, movement_type: 'sale', quotas: 101)
          expect(movement).not_to be_valid
          expect(movement.errors[:quotas]).to eq(
            ["QuotasAmountError"]
          )
        end
      end

      it 'have enough quota on create' do
        movement = build(:money_movement, movement_type: 'sale', quotas: 99)
        expect(movement).to be_valid
      end

      it 'doesnt have positive average_price' do
        movement = build(:money_movement, movement_type: 'sale', quotas: 99, average_price: 0)
        expect(movement).not_to be_valid
        expect(movement.errors[:average_price]).to eq(
          ["AveragePriceError"]
        )
      end

      it 'have positive average price on create' do
        movement = build(:money_movement, movement_type: 'sale', quotas: 99, average_price: 1)
        expect(movement).to be_valid
      end
    end
  end
end
