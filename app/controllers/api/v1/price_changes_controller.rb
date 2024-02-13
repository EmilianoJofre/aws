class Api::V1::PriceChangesController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  
  def create
    respond_with asset.price_changes.create!(create_params.merge(price_changed_at: Time.current))
  end

  private

  def asset
    InvestmentAsset.find(params['investment_asset_id'])
  end

  def create_params
    params.permit(
      :value
    )
  end
end
