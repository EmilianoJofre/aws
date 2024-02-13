require 'rails_helper'

RSpec.describe SelectedAccountsBalanceJob, type: :job do
  let(:relation) { create(:relation) }
  let(:account1) { create(:account, relation: relation) }
  let(:account2) { create(:account, relation: relation) }
  let(:id1) { account1.id.to_s }
  let(:id2) { account2.id.to_s }
  let(:selected_id) { id1 }
  let(:time_window) { '1m' }
  let(:date) { '2021-11-22' }
  let(:wallet_json) do
    { date => {
      id1 => { "CLP" => 1, "USD" => 1 },
      id2 => { "CLP" => 2, "USD" => 2 }
    } }
  end
  let(:balances_json) do
    { date => {
      id1 => { "balance" => { "CLP" => 3, "USD" => 3 } },
      id2 => { "balance" => { "CLP" => 4, "USD" => 4 } }
    } }
  end
  let!(:relation_history) do
    create(:relation_history,
           relation: relation,
           time_window: time_window,
           wallet_values: wallet_json.to_json,
           balances_values: balances_json.to_json)
  end

  def perform_now
    described_class.perform_now(relation, [selected_id], time_window)
  end

  describe 'perform_now' do
    let!(:returned_relation_history) { perform_now }
    let(:balances) { JSON.parse(returned_relation_history.balances_values) }
    let(:wallets) { JSON.parse(returned_relation_history.wallet_values) }

    it 'returns relation history' do
      expect(returned_relation_history).to be_a(RelationHistory)
    end

    it 'adds to balance selected accounts balances' do
      expect(balances[date]['selected']).to eq(balances_json[date][selected_id])
    end

    it 'adds to wallet selected accounts wallets' do
      expect(wallets[date]['selected']).to eq(wallet_json[date][selected_id])
    end
  end
end
