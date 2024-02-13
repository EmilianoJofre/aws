require 'rails_helper'

describe UpdateRelationHistoryTimeWindow do
  def perform(arg_relation)
    described_class.for(relation: arg_relation, time_window: time_window)
  end

  def command_params(arg_relation)
    { from: from_date, relation: arg_relation, step: step, to: now - 1.day }
  end

  let(:now) { Time.zone.local(2021, 3, 1).to_date }
  let(:from_date) { now - 1.month }
  let(:step) { 1 }
  let(:time_window) { '1m' }
  let(:relation) { create(:relation) }
  let(:no_history_relation) { create(:relation) }
  let!(:relation_history) do
    create(:relation_history,
           relation: relation, time_window: time_window, wallet_values: {}, balances_values: {})
  end
  let(:dummy_wallet_json) { { key: 'wallet' } }
  let(:dummy_balances_json) { { key: 'balances' } }

  before do
    Timecop.freeze(now)
  end

  context 'with existing relation history' do
    before do
      allow(WalletBalancesForDates).to receive(:for).with(
        command_params(relation)
      ).and_return(dummy_wallet_json)

      allow(RelationBalancesForDates).to receive(:for).with(
        command_params(relation)
      ).and_return(dummy_balances_json)
    end

    it 'update wallet values' do
      expect { perform(relation) }
        .to change { relation_history.reload.wallet_values }
        .from({}).to(dummy_wallet_json.to_json)
      expect(WalletBalancesForDates).to have_received(:for).with(command_params(relation)).once
    end

    it 'update balances values' do
      expect { perform(relation) }
        .to change { relation_history.reload.balances_values }
        .from({}).to(dummy_balances_json.to_json)
      expect(RelationBalancesForDates).to have_received(:for).with(command_params(relation)).once
    end
  end

  context 'with non existing relation history' do
    before do
      allow(WalletBalancesForDates).to receive(:for).and_return(dummy_wallet_json)
      allow(RelationBalancesForDates).to receive(:for).and_return(dummy_balances_json)
      perform(no_history_relation)
    end

    it 'creates Relation History record' do
      expect(RelationHistory.all.count).to eq(2)
    end

    it 'create record with correct wallet values' do
      expect(
        RelationHistory.find_by(
          relation: no_history_relation, time_window: time_window
        ).wallet_values
      ).to eq(dummy_wallet_json.to_json)

      expect(WalletBalancesForDates).to(
        have_received(:for).with(command_params(no_history_relation)).once
      )
    end

    it 'create record with correct balances values' do
      expect(
        RelationHistory.find_by(
          relation: no_history_relation, time_window: time_window
        ).balances_values
      ).to eq(dummy_balances_json.to_json)

      expect(RelationBalancesForDates).to(
        have_received(:for).with(command_params(no_history_relation)).once
      )
    end
  end
end
