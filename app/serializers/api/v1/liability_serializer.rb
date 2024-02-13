class Api::V1::LiabilitySerializer < Api::V1::BaseSerializer
  attributes :id, :name, :description, :investment_asset_id, :investment_asset, :initial_debt, :debt_participation, :total_fees, :fees_paid, :outstanding_balance, :start_date, :end_date, :payment_cycle, :rate, :rate_description, :rate_type

  def investment_asset
    return nil if object.investment_asset_id.nil?
     object.investment_asset.name
  end
end
