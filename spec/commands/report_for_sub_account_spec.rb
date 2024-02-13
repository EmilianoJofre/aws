require 'rails_helper'

describe ReportForSubAccount do
  def perform
    described_class.for(sub_account: sub_account)
  end

  let(:now) { Time.zone.local(2021, 2, 1) }
  let(:last_year) { Time.zone.local(2020, 1, 1) }
  let(:previous_month) { (now.beginning_of_month - 1.day) }
  let(:sub_account) { create(:sub_account) }
  let!(:wallet_deposit) do
    create(:wallet_deposit, sub_account_id: sub_account.id, amount: 200, date: previous_month)
  end
  let!(:wallet_deposit_two) do
    create(:wallet_deposit, sub_account_id: sub_account.id, amount: 300, date: previous_month)
  end
  let(:deposits_sum) { wallet_deposit.amount + wallet_deposit_two.amount }
  let!(:wallet_withdrawal) do
    create(:wallet_withdrawal, sub_account_id: sub_account.id, amount: 75, date: previous_month)
  end
  let!(:wallet_withdrawal_two) do
    create(:wallet_withdrawal, sub_account_id: sub_account.id, amount: 25, date: previous_month)
  end
  let(:withdrawals_sum) { wallet_withdrawal.amount + wallet_withdrawal_two.amount }
  let(:report) do
    {
      accumulated: {
        current: {
          profit_absolute: 900.0, profit_relative: 1.5
        },
        last: {
          profit_absolute: 150.0, profit_relative: 1.5, end_capital: 200.0
        }
      },
      previous_month.month => {
        initial_capital: 200.0,
        end_capital: 1500.0,
        profit_absolute: 900.0,
        profit_relative: 1.5,
        deposits: deposits_sum,
        withdrawals: withdrawals_sum
      }
    }
  end

  before do
    Timecop.freeze(now)
    allow(sub_account).to receive(:balance).with(
      previous_month.beginning_of_month
    ).and_return({ CLP: 200.0, USD: 0 })
    allow(sub_account).to receive(:balance).with(
      previous_month.end_of_month
    ).and_return({ CLP: 1500.0, USD: 0 })
    allow(sub_account).to receive(:wallet).with(
      previous_month.beginning_of_month
    ).and_return(0.0)
    allow(sub_account).to receive(:wallet).with(
      previous_month.end_of_month
    ).and_return(deposits_sum - withdrawals_sum)
    allow(sub_account).to receive(:balance).with(
      last_year.beginning_of_year
    ).and_return({ CLP: 100.0, USD: 0 })
    allow(sub_account).to receive(:balance).with(
      last_year.end_of_year
    ).and_return({ CLP: 200.0, USD: 0 })
    allow(sub_account).to receive(:wallet).with(
      last_year.beginning_of_year
    ).and_return(50.0)
    allow(sub_account).to receive(:wallet).with(
      last_year.end_of_year
    ).and_return(100.0)
  end

  it { expect(perform).to eq(report) }
end
