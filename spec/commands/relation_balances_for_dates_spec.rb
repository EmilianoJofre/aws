describe RelationBalancesForDates do
  def perform
    described_class.for(relation: relation, from: from, to: to, step: step)
  end

  let(:relation) { create(:relation) }
  let(:account1) { create(:account, relation: relation) }
  let(:account2) { create(:account, relation: relation) }
  let(:to) { Date.current }
  let(:from) { Date.current - 1.day }
  let(:step) { 1 }
  let(:balances) do
    {
      Date.current - 1.day => {
        :all => {
          balance: { CLP: 25, USD: 50 },
          name: "Todas tus cuentas"
        },
        account1.id => {
          balance: { CLP: 10, USD: 20 },
          bank: account1.bank.name,
          name: account1.name,
          rut: account1.rut
        },
        account2.id => {
          balance: { CLP: 15, USD: 30 },
          bank: account2.bank.name,
          name: account2.name,
          rut: account2.rut
        }
      },
      Date.current => {
        :all => {
          balance: { CLP: 25, USD: 50 },
          name: "Todas tus cuentas"
        },
        account1.id => {
          balance: { CLP: 5, USD: 10 },
          bank: account1.bank.name,
          name: account1.name,
          rut: account1.rut
        },
        account2.id => {
          balance: { CLP: 20, USD: 40 },
          bank: account2.bank.name,
          name: account2.name,
          rut: account2.rut
        }
      }
    }
  end

  before do
    allow(relation).to receive(:relation_accounts).and_return([account1, account2])
    allow(account1).to receive(:balance).with(
      (Date.current - 1.day).end_of_day
    ).and_return({ CLP: 10, USD: 20 })
    allow(account2).to receive(:balance).with(
      (Date.current - 1.day).end_of_day
    ).and_return({ CLP: 15, USD: 30 })
    allow(account1).to receive(:balance).with(
      Date.current.end_of_day
    ).and_return({ CLP: 5, USD: 10 })
    allow(account2).to receive(:balance).with(
      Date.current.end_of_day
    ).and_return({ CLP: 20, USD: 40 })
  end

  it { expect(perform).to eq(balances) }
end
