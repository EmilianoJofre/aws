describe RelationCurrentDistribution do
  def perform
    described_class.for(relation: relation)
  end

  let(:relation) { create(:relation) }
  let(:account) { create(:account, relation: relation) }
  let(:sub_account1) { create(:sub_account, currency: 'CLP', account: account) }
  let(:sub_account2) { create(:sub_account, currency: 'USD', account: account) }
  let(:asset1) { create(:investment_asset, asset_type: 0) }
  let(:asset2) { create(:investment_asset, asset_type: 1) }
  let(:membership1) { create(:membership, sub_account: sub_account1, investment_asset: asset1) }
  let(:membership2) { create(:membership, sub_account: sub_account2, investment_asset: asset2) }
  let!(:dollar) do
    create(:dollar_price, date: 1.business_day.before(Date.current), price: dollar_price)
  end
  let(:dollar_price) { 700 }
  let(:balance_clp) { 1000 }
  let(:balance_usd) { 10 }
  let(:memberships) { double }

  let(:distribution) do
    {
      'total' => (dollar_price * balance_usd) + balance_clp,
      'fixed_income' => balance_clp,
      'variable_income' => dollar_price * balance_usd
    }
  end

  before do
    allow(relation).to receive(:memberships).and_return(memberships)
    allow(memberships).to receive(:active).and_return([membership1, membership2])
    allow(membership1).to receive(
      :amount_updated_balance
    ).with(Date.current).and_return(balance_clp)
    allow(membership2).to receive(
      :amount_updated_balance
    ).with(Date.current).and_return(balance_usd)
  end

  it { expect(perform).to eq(distribution) }
end
