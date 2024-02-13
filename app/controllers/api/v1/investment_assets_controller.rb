# rubocop:disable Layout/LineLength
class Api::V1::InvestmentAssetsController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!

  def create
    respond_with InvestmentAsset.create!(create_params)
  end

  def index
    respond_with investment_assets, relation: relation, root: "investment_assets"
  end

  private

  def relation
    return @relation if !@relation.nil?
    return current_relation if !current_relation.nil?

    demo? ? DemoRelation&.find(params['relation_id']) : Relation&.find(params['relation_id'])
  end

  def investment_assets
    if demo?
      relation.demo_investment_assets.includes(:demo_memberships).where(memberships: { hidden: false }).distinct
    else
      relation.investment_assets.includes(:memberships).where(memberships: { hidden: false }).distinct
    end
  end

  def create_params
    params.permit(
      :name,
      :asset_id,
      :currency,
      :asset_type,
      sustainability:[
        :global_rating,
        :label
      ]
    )
  end

  def demo?
    params[:is_demo] == 'true'
  end
end
# rubocop:enable Layout/LineLength
