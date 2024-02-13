require 'rails_helper'

RSpec.describe RelationFile, type: :model do
  def build_file(build_params)
    build(:relation_file, build_params)
  end

  it 'has a valid factory' do
    expect(build(:relation_file)).to be_valid
  end

  describe 'validations' do
    let(:relation) { create(:relation) }
    let(:banks) { create_list(:bank, 2) }
    let(:first_account) { create(:account, bank: banks.first) }
    let(:second_account) { create(:account, relation: relation) }
    let(:sub_account) { create(:sub_account) }

    context 'when account is defined' do
      it 'is invalid with different Account Relation' do
        relation_file = build_file({ account: first_account })
        expect(relation_file).not_to be_valid
        expect(relation_file.errors[:account]).to eq(
          ["AccountRelationError"]
        )
      end

      it 'is invalid with different Account Bank' do
        relation_file = build_file(
          { account: second_account, relation: relation, bank: banks.last }
        )
        expect(relation_file).not_to be_valid
        expect(relation_file.errors[:account]).to eq(
          ["AccountBankError"]
        )
      end
    end

    context 'when sub_account is defined' do
      it 'is invalid with different SubAccount Account' do
        relation_file = build_file(
          { relation: relation, account: second_account, sub_account: sub_account  }
        )
        expect(relation_file).not_to be_valid
        expect(relation_file.errors[:account]).to eq(
          ["SubAccountAccountError"]
        )
      end
    end
  end

  describe 'callbacks' do
    let(:relation) { create(:relation) }
    let(:bank) { create(:bank) }
    let(:account) { create(:account, relation: relation, bank: bank) }
    let(:sub_account) { create(:sub_account, account: account) }

    context 'when creating/updating with SubAccount' do
      it 'backfills account' do
        file = build_file({ relation: relation, sub_account: sub_account })
        expect { file.valid? }
          .to change { file.account }
          .from(nil)
          .to(account)
      end

      it 'backfills bank' do
        file = build_file({ relation: relation, sub_account: sub_account })
        expect { file.valid? }
          .to change { file.bank }
          .from(nil)
          .to(bank)
      end
    end

    context 'when creating/updating with Account' do
      it 'backfills bank' do
        file = build_file({ relation: relation, account: account })
        expect { file.valid? }
          .to change { file.bank }
          .from(nil)
          .to(bank)
      end
    end
  end
end
